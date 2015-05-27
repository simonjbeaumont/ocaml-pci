#!/bin/sh

set -ex

COVERAGE_DIR=.coverage
rm -rf $COVERAGE_DIR
mkdir -p $COVERAGE_DIR
pushd $COVERAGE_DIR
trap "popd; rm -rf $COVERAGE_DIR" EXIT

$(which cp) -r ../* .

eval `opam config env`
opam install -y bisect_ppx oasis

sed -i '/BuildDepends:/ s/$/, bisect_ppx/' _oasis
oasis setup

./configure --enable-tests
make

find . -name bisect* | xargs rm -f
./test_pci.native

if [ -n "$TRAVIS" ]; then
  echo "\$TRAVIS set; sending coverage to coveralls.io..."
  echo "Getting patched version of bisect-report"
  curl -L http://bisect.sagotch.fr | tar -xzf -
  chmod +x Bisect/configure
  (cd Bisect; ./configure)
  make -C Bisect all
  echo "Generating coveralls data"
  (cd _build; \
    ../Bisect/_build/src/report/report.native \
      -coveralls-property service_job_id "$TRAVIS_JOB_ID" \
      -coveralls-property service_name "travis-ci" \
      -coveralls ../coveralls.json \
      ../bisect*.out)
  echo "Sending to coveralls.io"
  curl -F json_file=@coveralls.json https://coveralls.io/api/v1/jobs
else
  echo "\$TRAVIS not set; running bisect-report..."
  bisect-report bisect*.out -I _build -text report
  bisect-report bisect*.out -I _build -summary-only -text summary
  (cd _build; bisect-report ../bisect*.out -html ../report-html)
  cat report
  cat summary
fi
