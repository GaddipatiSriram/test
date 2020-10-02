#include    <pthread.h>
#include    <stdlib.h>

#include "simp_sem.h"
#include "diners.h"
#include "print.h"

#define KEY_OFFSET // Need number > 500

void take_forks (int);
void put_forks (int);
void test (int);

void think (int);
void eat (int);

int main (void)
{
    /* Setup needed local variables */
    pthread_t thread[N];
    int value[5] = {0,1,2,3,4};
    key_t key = 1234 ;
    /* Initialize non-interleaving printing using initPrinting() */
	mutex = initPrinting();

    /* Initialize philosopher semaphores (s[]) using sem_create() */
	for(int index = 0; index < N ; index++)
	{
		s[index] = sem_create(key++ , 0); 
	}
	

    /* Initialize critical section mutex using sem_create() */
    mutex = sem_create(key, 1); 
    
    /* Launch the philosopher threads */
	for(int index = 0; index < N ; index++)
	{
	  pthread_create(&thread[index], NULL, philosopher, (void *) &value[index]);
	}
     /* Wait for all the philosophers threads to finish */
    for(int index = 0; index < N ; index++)
	{
	  pthread_join(thread[index], NULL);
	}
	
     /* cleanup all semiphores and mutext using sem_close().
        This MUST BE DONE! */
	for(int index = 0; index < N ; index++)
	{
		sem_close(s[index]); 
	}

    endPrinting();

    exit (0);

}