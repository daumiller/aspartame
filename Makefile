all : libaspartame.so

tests : test0.bin

test0.bin : objects test0.m
	clang -o test0.bin test0.m *.o -I.. ../atropine/libatropine.so `pkg-config --cflags gdk-3.0 --libs gdk-3.0` `objfw-config --all`

objects : OMSignalManager.o OMDisplayManager.o OMDisplay.o OMScreen.o OMVisual.o OMWidget.o OMApplication.o OMWindow.o

%.o : %.m
	clang -c $^ -o $@ -I.. `objfw-config --cflags` `pkg-config --cflags gdk-3.0`

clean :
	rm -f *.o
	rm -f test0.bin
