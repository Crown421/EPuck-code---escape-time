/* 
 * File:   util.h
 * Author: franz
 *
 * Created on July 19, 2012, 6:03 PM
 */

#ifndef UTIL_H
#define	UTIL_H


#define PI 3.14159265358979
#define TURN_SPEED 1000
#define STEPS_FOR_2PI 1300.
#define MAX_SAMPLES 2048
#define NB_SENSORS  8		// number of sensors

#define RUN_SPEED 900 //500
#define WALLDIST 600

int waitforSignalChar(char);
int getGroundSensor(int);
void getmeanGround(int* );
void getmeanGroundAll(int* , int*);

void run(int);
void turnToDirection(double);
void followGetSensorValues(int *);
void srandUtil();

void _ISRFAST _T1Interrupt(void);
void InitTMR1(void);

void change_LEDs(int);



// special attributes for an interrupt  routine:
#define _ISRFAST   __attribute__((interrupt, shadow))
//#define _ISRFAST_NO_PSV __attribute__(interrupt, no_auto_psv))
//#define _ISRFAST_PSV __attribute__((interrupt, auto_psv))

#ifdef	__cplusplus
}
#endif

#endif	/* UTIL_H */

