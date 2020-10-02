/**
    This file contains functions prototypes to use for non-interleaving
    printing. JRD.
**/

#ifndef PRINTIT
#define PRINTIT

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

/**
    Initialize the print functions.  THIS SHOULD ONLY HAPPEN ONCE!
**/
int initPrinting();

/**
    Print the supplied string to stdout.
**/
void printIt(char* printString);

/**
    Remove the printing mutex.  Once called printIt() will not work until
    initPrinting() is called again.
**/
int endPrinting();

#endif
