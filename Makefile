all: update test

update:
	./update-overlay

test:
	nix build -f test.nix --show-trace

.PHONY: update test
