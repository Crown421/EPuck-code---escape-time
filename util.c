#include "motor_led/e_init_port.h"
#include "motor_led/e_epuck_ports.h"
#include "I2C/e_I2C_protocol.h"
#include "motor_led/e_motors.h"
#include <motor_led/advance_one_timer/e_led.h>
#include <motor_led/advance_one_timer/e_agenda.h>
#include "a_d/advance_ad_scan/e_prox.h"
#include "a_d/advance_ad_scan/e_ad_conv.h"
#include "a_d/advance_ad_scan/e_micro.h"
#include <uart/e_uart_char.h>

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

int cntTimer;
extern char buffer[100];

int waitforSignalChar(char sig){
    int gotchar = 0;
    char car;
    //change_LEDs(TRUE);
    e_activate_agenda(snake_led,1000);
    //e_start_agendas_processing();
    do {
        wait(100);
        //sprintf(buffer, "Ping \r\n");
        //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
        if ( e_getchar_uart1(&car) && (car == sig) ){
            gotchar = 1;
            sprintf(buffer, " %c \r\n", car);
            e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
            //sprintf(buffer, " %c \r\n", car);
            //e_send_uart1_char(&car, 1); while(e_uart1_sending());
        }
    }while( (!gotchar) );
    //change_LEDs(FALSE);
    //e_end_agendas_processing();
    e_destroy_agenda(snake_led);
    wait(80000);
    return gotchar;
}

int getGroundSensor(int nr){
    if (nr < 0 || nr > 2){
        return -1;
    }

    int res;
    e_i2cp_enable();
    e_i2cp_read(0xC0, 0);
    res = (unsigned char) e_i2cp_read(0xC0, 2*nr);
    res <<= 8;
    res += (unsigned char) e_i2cp_read(0xC0, 2*nr+1);
    e_i2cp_disable();
    return res;
}

void getmeanGround(int* meanval){
    int i;
    *meanval=0;
    for(i=0;i<=2;i++){
        *meanval += getGroundSensor(i);
    }
    *meanval /=3;
}

void getmeanGroundAll(int* meanval, int *vals){
    int i;
    *meanval=0;
    for(i=0;i<3;i++){
        vals[i]= getGroundSensor(i);
        *meanval += vals[i];
    }
    *meanval /=3;
}

void run(int run_Speed){
    LED4 = TRUE;    
    e_set_speed_left(run_Speed);
    e_set_speed_right(run_Speed);
    LED4 = FALSE; 
    
}

// Turns the robot towards the given direction
// direction in [0, 2pi]
void turnToDirection(double direction){
    LED3 = TRUE;
    LED5 = TRUE;
    int end_turn;
    if (direction < 0) direction = direction + 2*PI;
    if (direction > 2*PI) direction = direction - 2*PI;


    if (direction < PI)     // turn clockwise
    {
        e_set_steps_left(0);
        end_turn = (int)(STEPS_FOR_2PI*(direction/(2*PI)));

        e_set_speed_left(TURN_SPEED);  // motor speed in steps/s
        e_set_speed_right(-TURN_SPEED);  // motor speed in steps/s

        while(e_get_steps_left() < end_turn);   // turn until done
    }
    else 					// turn counterclockwise
    {
        e_set_steps_right(0);
        end_turn = (int)(STEPS_FOR_2PI*((2*PI-direction)/(2*PI)));

        e_set_speed_left(-TURN_SPEED);  // motor speed in steps/s
        e_set_speed_right(TURN_SPEED);  // motor speed in steps/s

        while(e_get_steps_right() < end_turn);   // turn until done*/
    }
    // stop motors
    e_set_speed_left(0);
    e_set_speed_right(0);
    LED3 = FALSE;
    LED5 = FALSE;
}

int follow_sensorzero[8];
void followGetSensorValues(int *sensorTable) {
	unsigned int i;
	for (i=0; i < NB_SENSORS; i++) {
		sensorTable[i] = e_get_prox(i) - follow_sensorzero[i];
	}
}

void srandUtil(){
    int distances[NB_SENSORS];		// array keeping the distance sensor readings
    unsigned int randSeed = 0;
    followGetSensorValues(distances);
    randSeed += distances[0] + distances[4] + distances[7];
    randSeed += getGroundSensor(0);
    
    srand(randSeed);
}

void _ISRFAST _T1Interrupt(void)
{
    cntTimer++;
    IFS0bits.T1IF = 0;            // clear interrupt flag
}

void InitTMR1(void)
{
    cntTimer = 0;
    T1CON = 0;                    //
    T1CONbits.TCKPS=3;            // prescsaler = 256
    TMR1 = 0;                     // clear timer 5
    PR1 = (100.0*MILLISEC)/256.0; // interrupt every 100ms with 256 prescaler
    IFS0bits.T1IF = 0;            // clear interrupt flag
    IEC0bits.T1IE = 1;            // set interrupt enable bit
    T1CONbits.TON = 1;            // start Timer5
}

void change_LEDs(int value)
{
            LED0 = value;
            LED1 = value; 
            LED2 = value; 
            LED3 = value;
            LED4 = value;
            LED5 = value;
            LED6 = value; 
            LED7 = value; 
    
}


