
.PHONY: fmt
fmt:
	shfmt -w git-xcleaner

.PHONY: tag
tag:
	tito tag

.PHONY: release
release:
	tito build --tgz
	scp -i $HOME/.ssh/fedorapeople_rsa /tmp/tito/git-xcleaner-*.tar.gz lzap@fedorapeople.org:public_html/projects/git-xcleaner/
	rm -rf /tmp/tito
