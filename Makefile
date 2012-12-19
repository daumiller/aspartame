all : libaspartame.so

objects : OMSignalManager.o OMDisplayManager.o OMDisplay.o OMScreen.o OMVisual.o OMWidget.o

%.o : %.m
	clang -c $^ -o $@ -I.. `pkg-config --cflags gdk-3.0`

clean :
	rm -f *.o
