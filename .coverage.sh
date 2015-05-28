#!/bin/sh

set -ex

COVERAGE_DIR=.coverage
rm -rf $COVERAGE_DIR
mkdir -p $COVERAGE_DIR
pushd $COVERAGE_DIR
trap "popd; rm -rf $COVERAGE_DIR" EXIT

$(which cp) -r ../* .

eval `opam config env`
opam install -y bisect_ppx oasis ocveralls

sed -i '/BuildDepends:/ s/$/, bisect_ppx/' _oasis
oasis setup

./configure --enable-tests
make

find . -name bisect* | xargs rm -f
./test_pci.native -runner sequential

bisect-report bisect*.out -I _build -text report
bisect-report bisect*.out -I _build -summary-only -text summary
(cd _build; bisect-report ../bisect*.out -html ../report-html)

if [ -n "$TRAVIS" ]; then
  # echo "\$TRAVIS set; running ocveralls and sending to coveralls.io..."
  # ocveralls --prefix _build bisect* --send
  if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This is not a pull-request, not pushing report to gh-pages..."
    exit 0
  fi
  GHPDIR=gh-pages
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/simonjbeaumont/ocaml-pci $GHPDIR > /dev/null
  (cd _build; bisect-report ../bisect*.out -html ../$GHPDIR/coverage)

  PERCENTAGE=$(grep total summary | awk '{print $4}' | tr -d "()%" | cut -d. -f1)

  if   [ "$PERCENTAGE" -ge 95 ]; then COLOR="brightgreen"
  elif [ "$PERCENTAGE" -ge 85 ]; then COLOR="green"
  elif [ "$PERCENTAGE" -ge 75 ]; then COLOR="yellowgreen"
  elif [ "$PERCENTAGE" -ge 65 ]; then COLOR="yellow"
  elif [ "$PERCENTAGE" -ge 50 ]; then COLOR="orange"
  elif [ "$PERCENTAGE" -ge 00 ]; then COLOR="red"
  else                                COLOR="lightgrey"; PERCENTAGE="unknown"
  fi
  echo "<img src=\"http://img.shields.io/badge/coverage-$PERCENTAGE%-$COLOR\"/>" > $GHPDIR/coverage/badge.html

  git -C $GHPDIR config user.email "travis@travis-ci.org"
  git -C $GHPDIR config user.name "Travis"
  git -C $GHPDIR add coverage
  git -C $GHPDIR commit --allow-empty -m "Travis build $TRAVIS_BUILD_NUMBER pushed coverage to gh-pages"
  git -C $GHPDIR push origin gh-pages > /dev/null
else
  echo "\$TRAVIS not set; displaying results of bisect-report..."
  cat report
  cat summary
fi
