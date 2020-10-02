/**
    This file contains functions to use for non-interleaving printing. JRD.
**/

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

// GLOBAL VARIABLES.

static pthread_mutex_t printMutex;

/**
    Initialize the print functions.  THIS SHOULD ONLY HAPPEN ONCE!
**/
int initPrinting()
{
    return pthread_mutex_init(&printMutex, NULL);
}

/**
    Print the supplied string to stdout.
**/
void printIt(char* printString)
{
    pthread_mutex_lock(&printMutex);
    printf("%s", printString);
    usleep(100000);
    pthread_mutex_unlock(&printMutex);
}

/**
    Remove the printing mutex.  Once called printIt() will not work until
    initPrinting() is called again.
**/
int endPrinting()
{
    return pthread_mutex_destroy(&printMutex);
}

