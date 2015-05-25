#!/bin/sh

eval `opam config env`
opam install -y bisect_ppx oasis ocveralls

sed '/BuildDepends:/ s/$/, bisect_ppx/' _oasis > _oasis_with_bisect
oasis setup -oasis _oasis_with_bisect

./configure --enable-tests
make

rm -f _build/bisect*
BISECT_FILE=_build/bisect ./test_pci.native

ocveralls --prefix _build _build/bisect* --send
