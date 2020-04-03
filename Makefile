.PHONY: all test clean

all:
	dune build --profile=release

test:
	dune runtest -p pci

install:
	dune install pci

doc:
	dune build -p pci @doc

clean:
	dune clean

gh-pages:
	bash .docgen.sh

travis-coveralls.sh:
	wget https://raw.githubusercontent.com/simonjbeaumont/ocaml-travis-coveralls/master/$@

coverage: travis-coveralls.sh
	bash $<
