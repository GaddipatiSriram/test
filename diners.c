
#include	<sys/types.h>
#include	<sys/ipc.h>
#include	<sys/sem.h>
#include	<unistd.h>
#include	<sched.h>
#include	<stdio.h>
#include	<errno.h>

#include "simp_sem.h"
#include "diners.h"
#include "print.h" // JRD.

/*
 * Taken from "Operating Systems - Design and Implementation" by Tanenbaum
 * Section 2.3, page 91, Figure 2-10
 */
#define LEFT 		(i + N - 1) % N	/* i's left neighbor */
#define RIGHT 		(i + 1) % N	/* i's right neighbor */
#define THINKING	0		/* philosopher states */
#define HUNGRY		1
#define EATING		2

int state[N];
semaphore s[N];
semaphore mutex;


void take_forks (int);
void put_forks (int);
void test (int);

void think (int);
void eat (int);

void *philosopher (void *in)
{
	int i = *(int *)in;
	int awhile = 5;
    char printBuffer[128]; // JRD.

    snprintf(printBuffer, sizeof(printBuffer),
        "PHIL[%d] STARTED\n", i);
    printIt(printBuffer);

	while (awhile--)
	{
		think(i);
		take_forks(i);
		eat(i);
		put_forks (i);
        snprintf(printBuffer, sizeof(printBuffer),
            "PHIL[%d] count: %d\n", i, awhile);
        printIt(printBuffer);
	}
}

void
take_forks (int i)
{
	sem_wait (mutex);
	state[i] = HUNGRY;
	test(i);
	sem_signal (mutex);
	sem_wait (s[i]);
}

void
put_forks (int i)
{
	sem_wait (mutex);
	state[i] = THINKING;
	test(LEFT);
	test(RIGHT);
	sem_signal (mutex);
}

void
test (int i)
{
	if (state[i] == HUNGRY &&
		state[LEFT] != EATING &&
		state[RIGHT] != EATING)
	{
		state[i] = EATING;
		sem_signal (s[i]);
	}
}

void think (int i)
{
    char printBuffer[128]; // JRD.

	// fprintf(stderr, "Philosopher %d thinking\n", i);
	snprintf(printBuffer, sizeof(printBuffer), "Philosopher %d thinking\n", i);
    printIt(printBuffer);
	usleep (2000000);
	// fprintf(stderr, "Philosopher %d done thinking\n", i);
	snprintf(printBuffer, sizeof(printBuffer),
        "Philosopher %d done thinking\n", i);
    printIt(printBuffer);
}

void eat (int i)
{
    char printBuffer[128]; // JRD.

	// fprintf (stderr, "Philosopher %d eating (%d, %d)\n", i, state[LEFT], state[RIGHT]);
	snprintf(printBuffer, sizeof(printBuffer),
        "Philosopher %d eating (%d, %d)\n", i, state[LEFT], state[RIGHT]);
    printIt(printBuffer);
	usleep (1000000);
	// fprintf(stderr, "Philosopher %d done eating\n", i);
	snprintf(printBuffer, sizeof(printBuffer),
        "Philosopher %d done eating\n", i);
    printIt(printBuffer);
}
