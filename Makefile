all: update format test

update:
	./update-overlay

test:
	nix build -f test.nix --show-trace

format:
	nixfmt $$(find . -name \*.nix)


.PHONY: update test format all
