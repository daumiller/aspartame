# ----- all -----
all : lib test

# ----- lib -----
lib : libaspartame.so

libaspartame.so : objects libatropine.so
	clang -shared *.o -o libaspartame.so libatropine.so `objfw-config --libs` `pkg-config --libs gdk-3.0 pango`

# ----- test -----
test : test0.bin

test0.bin : test0.m libaspartame.so libatropine.so
	clang -o test0.bin test0.m -rpath . libatropine.so libaspartame.so -I.. `pkg-config --cflags gdk-3.0 --libs gdk-3.0` `objfw-config --all`

# ----- atropine -----
libatropine.so : ../atropine/libatropine.so
	cp ../atropine/libatropine.so ./

# ----- objects -----
objects : OMSignalManager.o OMDisplayManager.o OMDisplay.o OMScreen.o OMVisual.o OMWidget.o OMApplication.o OMWindow.o OMButton.o

%.o : %.m
	clang -c $^ -o $@ -I.. `objfw-config --cflags` `pkg-config --cflags gdk-3.0`

# ----- clean -----
clean :
	rm -f *.o
	rm -f *.a
	rm -f *.so
	rm -f test0.bin
