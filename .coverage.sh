#!/bin/sh

eval `opam config env`
opam install -y bisect_ppx oasis

sed '/BuildDepends:/ s/$/, bisect_ppx/' _oasis > _oasis_with_bisect
oasis setup -oasis _oasis_with_bisect

./configure --enable-tests
make

BISECT_FILE=_build/bisect ./test_pci.native
