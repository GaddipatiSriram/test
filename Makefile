all: diners

diners: diners.o main.o simp_sem.o print.o Makefile
	cc -o diners -pthread diners.o main.o simp_sem.o print.o

diners.o: diners.c
	cc -c diners.c

main.o: main.c
	cc -c main.c

simp_sem.o: simp_sem.c
	cc -c simp_sem.c

print.o: print.c
	cc -c print.c

clean:
	rm -f diners.o simp_sem.o print.o
