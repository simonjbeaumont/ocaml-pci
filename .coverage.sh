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
./test_pci.native

if [ -n "$TRAVIS" ]; then
  echo "\$TRAVIS set; running ocveralls and sending to coveralls.io..."
  ocveralls --prefix _build bisect* --send

  if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This is not a pull-request, not pushing report to gh-pages..."
    exit 0
  fi
  GHPDIR=gh-pages
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/simonjbeaumont/ocaml-pci $GHPDIR > /dev/null
  (cd _build; bisect-report ../bisect*.out -html ../$GHPDIR/coverage)

  git -C $GHPDIR config user.email "travis@travis-ci.org"
  git -C $GHPDIR config user.name "Travis"
  git -C $GHPDIR commit --allow-empty -am "Travis build $TRAVIS_BUILD_NUMBER pushed coverage to gh-pages"
  git -C $GHPDIR push origin gh-pages > /dev/null
else
  echo "\$TRAVIS not set; running bisect-report..."
  bisect-report bisect*.out -I _build -text report
  bisect-report bisect*.out -I _build -summary-only -text summary
  (cd _build; bisect-report ../bisect*.out -html ../report-html)
  cat report
  cat summary
fi
