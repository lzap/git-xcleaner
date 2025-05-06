
.PHONY: fmt
fmt:
	shfmt -w git-xcleaner

.PHONY: build
build:
	tito build --tgz

.PHONY: release
release:
	scp -i $HOME/.ssh/fedorapeople_rsa *.tar.gz lzap@fedorapeople.org:public_html/projects/git-xcleaner/
