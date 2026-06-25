.PHONY: fmt test
fmt:
	shfmt -w git-xcleaner test.sh

test:
	./test.sh

.PHONY: release
release:
	echo "Make sure git tag X.Y exists."

.PHONY: sources
sources:
	curl -L -O https://github.com/lzap/git-xcleaner/archive/refs/tags/$(shell git describe --tags --abbrev=0).tar.gz
