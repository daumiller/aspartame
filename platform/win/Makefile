all : objects

objects : platform.o

platform.o : platform.m
	clang -c -o platform.o platform.m -I./.. -I./../.. -I./../../../atropine `objfw-config --all`

clean :
	rm -f *.o
