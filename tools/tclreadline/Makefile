1:
	gcc -c tclreadline.c
2:
	gcc -shared -o libtclreadline.so tclreadline.o -lreadline -lncurses -ltcl8.6

install:
	mkdir -p             ~/usr/local/lib/tclreadline
	cp tclreadline*.tcl  ~/usr/local/lib/tclreadline
	cp libtclreadline.so ~/usr/local/lib/tclreadline
	cp pkgIndex.tcl      ~/usr/local/lib/tclreadline

clean:
	rm libtclreadline.so tclreadline.o
