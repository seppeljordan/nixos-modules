NIX_PATH=nixpkgs=$(shell cat .nixpkgs-url)

all: update test

update:
	./update-nixpkgs
	./update-overlay

test:
	nix build -f test.nix --show-trace

.PHONY: update test
