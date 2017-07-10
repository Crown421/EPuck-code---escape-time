/* 
 * File:   util_legacy.h
 * Author: Steffen
 *
 * Created on 23 May 2017, 14:31
 */

#ifndef UTIL_LEGACY_H
#define	UTIL_LEGACY_H

#ifdef	__cplusplus
extern "C" {
#endif
    
#define PI 3.14159265358979
#define TURN_SPEED 1000
#define STEPS_FOR_2PI 1300.
#define MAX_SAMPLES 2048
#define NB_SENSORS  8		// number of sensors

#define RUN_SPEED 900 //500
#define WALLDIST 600
    

void showLED(float);
int detectFloorEvent(int);
void follow_sensor_calibrate();
double detectDistanceEvent(int);
int calcMax(int param[], int size);
double getGaussian();



#ifdef	__cplusplus
}
#endif

#endif	/* UTIL_LEGACY_H */

