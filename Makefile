
s:
	cd tools/server ; make 1

1:
	@git difftool -tool=diff --name-only master origin/master

d:
	@git diff master origin/master

f:
	@git fetch origin

