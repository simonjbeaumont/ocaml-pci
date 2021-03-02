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

format:
	dune build @fmt --auto-promote
