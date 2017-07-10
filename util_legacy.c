#include "motor_led/e_init_port.h"
#include "motor_led/e_epuck_ports.h"
#include "I2C/e_I2C_protocol.h"
#include "motor_led/e_motors.h"
#include "a_d/advance_ad_scan/e_prox.h"
#include "a_d/advance_ad_scan/e_ad_conv.h"
#include "a_d/advance_ad_scan/e_micro.h"

#include "stdio.h"
#include "string.h"
#include <stdlib.h>
#include <string.h>
#include "math.h"
#include "util.h"

#include <utility/utility.h>



//#include <p30f6014A.inc>
#include "C:\Program Files (x86)\Microchip\MPLAB C30\support\h\p30F6014A.h"
#include <C:\Program Files (x86)\Microchip\MPLAB C30\support\h\libpic30.h>

extern int cntTimer;
extern int follow_sensorzero[8];


int detectFloorEvent(int black){
    return (getGroundSensor(0) < black &&
            getGroundSensor(1) < black &&
            getGroundSensor(2) < black);
}


void follow_sensor_calibrate() {
	int i, j;
	long sensor[8];

	for (i=0; i<8; i++) {
		sensor[i]=0;
	}

	for (j=0; j<32; j++) {
		for (i=0; i<8; i++) {
			sensor[i]+=e_get_prox(i);
		}
		wait(10000);
	}

	for (i=0; i<8; i++) {
		follow_sensorzero[i]=(sensor[i]>>5);
	}

	wait(100000);
}


double detectDistanceEvent(int wallDist ){
    int distances[NB_SENSORS];		// array keeping the distance sensor readings
    followGetSensorValues(distances);

    if (distances[0] > wallDist){
        return -0.9*PI;

    }

    if (distances[7] > wallDist){
        return  0.9*PI;
    }

    if (distances[1] > wallDist){
        return -0.6*PI;
    }

    if (distances[6] > wallDist){
        return  0.6*PI;
    }

    return 2*PI+1;
}


double getGaussian(){
    double theta = 2*PI*(double)rand()/RAND_MAX;
    double D = -2*log((double)rand()/RAND_MAX);
    return sqrt(D)*cos(theta);
}



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//		show led
//
// Lights up the LED in the appropriate direction
//
// in:  float (angle between 0 and 2PI clockwise)
// out: void
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


void showLED(float angle)
{
    if (angle < 0) angle += 2.0*PI;
	int led_nb = 6;
	long int i;

	// led_nb corresponds to the appropriate bit number in the LATA register
	if ( angle > (PI/8) )
		led_nb = 7;
	if ( angle > (3*PI/8) )
		led_nb = 9;
	if ( angle > (5*PI/8) )
		led_nb = 12;
	if ( angle > (7*PI/8) )
		led_nb = 10;
	if ( angle > (9*PI/8) )
		led_nb = 13;
	if ( angle > (11*PI/8) )
		led_nb = 14;
	if ( angle > (13*PI/8) )
		led_nb = 15;
	if ( angle > (15*PI/8) )
		led_nb = 6;

	// set the bit on PortA to illuminate the led
	LATA = 1 << led_nb;

	for (i=0;i<500000;i++);   // Wait to indicate the direction

	LATA = 0;	// turn all LEDs off
}

int calcMax(int param[], int size)
{   
int a = 0;   
int i;
for (i = 0; i < size; i++)
  {
    if(param[i] > a)
      a = param[i];
  }

return a;
}
