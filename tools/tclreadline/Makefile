1:
	gcc -fPIC -c tclreadline.c -I/usr/include/tcl8.6
2:
	gcc -shared -o libtclreadline.so tclreadline.o -lreadline -lncurses -ltcl8.6

install:
	mkdir -p             ~/usr/local/lib/tclreadline
	cp tclreadline*.tcl  ~/usr/local/lib/tclreadline
	cp libtclreadline.so ~/usr/local/lib/tclreadline
	cp pkgIndex.tcl      ~/usr/local/lib/tclreadline

clean:
	rm libtclreadline.so tclreadline.o
