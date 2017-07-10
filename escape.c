#include "escape.h"

#include "C:\Program Files (x86)\Microchip\MPLAB C30\support\h\p30F6014A.h"
#include "stdio.h"
#include "string.h"
#include <stdlib.h>
#include <string.h>
#include "math.h"


#include <motor_led/e_init_port.h>
#include "motor_led/e_epuck_ports.h"
//extern char local_bt_PIN[4];
#include <bluetooth/e_bluetooth.h>
#include <motor_led/advance_one_timer/e_led.h>
#include <motor_led/advance_one_timer/e_motors.h>
//#include <motor_led/advance_one_timer/e_agenda.h>
//#include <camera/fast_2_timer/e_poxxxx.h>
#include <uart/e_uart_char.h>
//#include <a_d/advance_ad_scan/e_ad_conv.h>
#include <a_d/advance_ad_scan/e_prox.h>
//#include <a_d/advance_ad_scan/e_acc.h>
//#include <a_d/advance_ad_scan/e_micro.h>
//#include <utility/utility.h>

//#define FCY 28000000ULL
#include <C:\Program Files (x86)\Microchip\MPLAB C30\support\h\libpic30.h>

#include "memory.h"
extern char buffer[BUFFER_SIZE];
extern int cntTimer;
extern int selector;
//extern char buffer[100];

#include "util.h"
#include <utility/utility.h>



void run_escape()
{   
    sprintf(buffer, "Escape\r\n");
    wait(100000);
    e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    int lastEvent = 0, i;  
    double lambda = 0.15;
    InitTMR1();
    int distances[NB_SENSORS];		// array keeping the distance sensor readings
    int hitDistance = 1950;
    int groundval[3]; // slanted for removal, once this shit works
    int nmean = 3;
    int runningmean_v[nmean];
    int runningmean;
        
    int regspeed = 325;
    change_LEDs(FALSE);
    
    //sprintf(buffer, "Finding Seed\r\n");
    //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    
    unsigned int randSeed = 0;
    followGetSensorValues(distances);
    randSeed += distances[0] + distances[4] + distances[7];
    randSeed += getGroundSensor(0);
    randSeed *= distances[1];
    srand(randSeed);
    
    
    wait(100);
    //__delay_ms(2000);
    //run(regspeed);
    
// ** turn into some random initial direction
    double direction = (double)rand()/RAND_MAX*2.0*PI;
    //sprintf(buffer, "  Random Seed: %d %f \n ", randSeed, direction);
    //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    turnToDirection(direction);
    
// ** setup completed, wait for signal from Matlab
    waitforSignalChar('1');

// ** set LEDs, get ground values, start moving
    change_LEDs(FALSE);
    LED1 = TRUE;
    LED7 = TRUE;
    
    getmeanGround(&runningmean_v[0]);
    for (i=1; i<nmean; i++){
            runningmean_v[i] = runningmean_v[0];
        }
    
    lastEvent = cntTimer;
    int cntstart = cntTimer;
    int counter = 0;
    run(regspeed);
    
    while (1) {
        // Every 100ms have chance of lambda to turn to some dir
        if (cntTimer != lastEvent){
            // Calculate the turning rate
            double tmp = (double)rand()/RAND_MAX;
            // Check for tumble
            if (tmp < lambda){
                // Choose a new direction at random
                direction = (double)rand()/RAND_MAX*2.0*PI;
                //sprintf(buffer, "  Tumble\n");
                //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());

                // Turn into that direction
                turnToDirection(direction);
                run(regspeed); // set both wheels speed to regspeed
            }
            lastEvent = cntTimer;
        }
        
        // Get the sensor readings. They are large positive numbers around 
        // 1,000-3,500 when an object is very close, and close to 0 when no 
        // objects are close.
        followGetSensorValues(distances);
        
        if (distances[0] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(-0.9*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  

        }

        if (distances[7] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(0.9*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  
        }

        if (distances[1] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(-0.6*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  
        }

        if (distances[6] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(0.6*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  
        }
        
        
        // update the running mean, less than nmean-1, so highest value nmean-2
        for(i=0; i<nmean-1; i++){
            runningmean_v[i]=runningmean_v[i+1];
        }
        //getmeanGround(&runningmean_v[nmean-1]);
        getmeanGroundAll(&runningmean_v[nmean-1], &groundval);
                        
        // print appropriate mean to test in matlab, compute mean from running vector, print that as well
        runningmean = 0;
        for(i=0; i<nmean; i++){
            runningmean += runningmean_v[i];
        }
        runningmean /= nmean;
        
        counter++;
        
        sprintf(buffer, "%d, %d, %d, %d, %d, %d, %d, %d, -1, \r\n", selector, groundval[0],groundval[1],groundval[2], runningmean_v[nmean-1], runningmean,cntTimer-cntstart, counter );
        e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
        
    }
}




void run_escape_dummy()
{   
    sprintf(buffer, "Escape dummy\r\n");
    wait(100000);
    e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    int lastEvent = 0, i;  
    double lambda = 0.15;
    InitTMR1();
    int distances[NB_SENSORS];		// array keeping the distance sensor readings
    int hitDistance = 1950;
//    int groundval[3]; // slanted for removal, once this shit works
    int nmean = 3;
    int runningmean_v[nmean];
//    int runningmean;
    
    int pos_speeds[11] = {325, 367, 410, 452, 495, 537, 580, 622, 665, 707, 750};
    int regspeed = pos_speeds[selector-2];
    change_LEDs(FALSE);
    
    //sprintf(buffer, "Finding Seed\r\n");
    //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    
    unsigned int randSeed = 0;
    followGetSensorValues(distances);
    randSeed += distances[0] + distances[4] + distances[7];
    randSeed += getGroundSensor(0);
    randSeed *= distances[1];
    srand(randSeed);
    
    
    wait(100);
    //__delay_ms(2000);
    //run(regspeed);
    
// ** turn into some random initial direction
    double direction = (double)rand()/RAND_MAX*2.0*PI;
    //sprintf(buffer, "  Random Seed: %d %f \n ", randSeed, direction);
    //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    turnToDirection(direction);
    
// ** setup completed, wait for signal from Matlab
//    waitforSignalChar('1');

// ** set LEDs, get ground values, start moving
    LED1 = TRUE;
    LED7 = TRUE;
    
    getmeanGround(&runningmean_v[0]);
    for (i=1; i<nmean; i++){
            runningmean_v[i] = runningmean_v[0];
        }
    
    lastEvent = cntTimer;
//    int cntstart = cntTimer;
//    int counter = 0;
    run(regspeed);
    
    while (1) {
        // Every 100ms have chance of lambda to turn to some dir
        if (cntTimer != lastEvent){
            // Calculate the turning rate
            double tmp = (double)rand()/RAND_MAX;
            // Check for tumble
            if (tmp < lambda){
                // Choose a new direction at random
                direction = (double)rand()/RAND_MAX*2.0*PI;
                //sprintf(buffer, "  Tumble\n");
                //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());

                // Turn into that direction
                turnToDirection(direction);
                run(regspeed); // set both wheels speed to regspeed
            }
            lastEvent = cntTimer;
        }
        
        // Get the sensor readings. They are large positive numbers around 
        // 1,000-3,500 when an object is very close, and close to 0 when no 
        // objects are close.
        followGetSensorValues(distances);
        
        if (distances[0] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(-0.9*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  

        }

        if (distances[7] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(0.9*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  
        }

        if (distances[1] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(-0.6*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  
        }

        if (distances[6] > hitDistance){
            LED2 = TRUE;
            LED6 = TRUE;
            run(0); // stop motor
            turnToDirection(0.6*PI);
            run(regspeed);
            LED2 = FALSE;
            LED6 = FALSE;  
        }
        
        
//        // update the running mean, less than nmean-1, so highest value nmean-2
//        for(i=0; i<nmean-1; i++){
//            runningmean_v[i]=runningmean_v[i+1];
//        }
//        //getmeanGround(&runningmean_v[nmean-1]);
//        getmeanGroundAll(&runningmean_v[nmean-1], &groundval);
//                        
//        // print appropriate mean to test in matlab, compute mean from running vector, print that as well
//        runningmean = 0;
//        for(i=0; i<nmean; i++){
//            runningmean += runningmean_v[i];
//        }
//        runningmean /= nmean;
//        
//        counter++;
//        
//        sprintf(buffer, "%d, %d, %d, %d, %d, %d, %d, %d \r\n", selector, groundval[0],groundval[1],groundval[2], runningmean_v[nmean-1], runningmean,cntTimer-cntstart, counter );
//        e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
        
    }
}

    
    


// drives forwards and sends data to matlab, used for interface test and 
void run_ground_matlab()
{   
       
    sprintf(buffer, "Matlab connection\r\n");
    e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    wait(100000);
    
    // possibly add blinking
    
    
    
    //char testbuf[100];
    //e_bt_read_local_pin_number(testbuf);
    //sprintf(buffer,"\n\rPIN code = %s",local_bt_PIN);
    //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    
    int i;  
    InitTMR1();
    int distances[NB_SENSORS];		// array keeping the distance sensor readings
    int hitDistance = 2050;
    
    int groundval[3]; // slanted for removal, once this shit works
    //int meangroundval;
    int nmean = 3;
    int runningmean_v[nmean];
    int runningmean;
        
    int regspeed = 350;
    change_LEDs(FALSE);
    
    waitforSignalChar('1');
    
    int cntstart = cntTimer;
    int counter = 0;
    
    // initialise running mean
    getmeanGround(&runningmean_v[0]);
    
    for (i=1; i<nmean; i++){
            runningmean_v[i] = runningmean_v[0];
        }
    
    
    LED1 = TRUE;
    LED7 = TRUE;
    wait(100);
    //__delay_ms(2000);

    run(regspeed);
    
    //sprintf(buffer, "Start Escaping\r\n");
    //e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
    
    while (1) {
        // Get the sensor readings. They are large positive numbers around 
        // 1,000-3,500 when an object is very close, and close to 0 when no 
        // objects are close.
        followGetSensorValues(distances);
        
        if(distances[0] > hitDistance || distances[1] > hitDistance || distances[6] > hitDistance || distances[7] > hitDistance)
        {
            run(0);
            //wait(10000);
            sprintf(buffer, "0, 0, 0, 0, 0, 0, 0, 0\r\n");
            //sprintf(buffer, "\r\nSomething hit!\r\n");
            e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
             // stop motor
            //__delay_ms(30);
            
            change_LEDs(TRUE);
            wait(100000000);
        }
        
        //wait(10);
         /*
        for (i=0; i<3; i++){
            groundval[i] = getGroundSensor(i);
        }
         */
        
        
        // update the running mean, less than nmean-1, so highest value nmean-2
        for(i=0; i<nmean-1; i++){
            runningmean_v[i]=runningmean_v[i+1];
        }
        //getmeanGround(&runningmean_v[nmean-1]);
        getmeanGroundAll(&runningmean_v[nmean-1], &groundval);
                        
        // print appropriate mean to test in matlab, compute mean from running vector, print that as well
        runningmean = 0;
        for(i=0; i<nmean; i++){
            runningmean += runningmean_v[i];
        }
        runningmean /= nmean;
        
        counter++;
        
        sprintf(buffer, "%d, %d, %d, %d, %d, %d, %d, %d, -1, \r\n", selector, groundval[0],groundval[1],groundval[2], runningmean_v[nmean-1], runningmean,cntTimer-cntstart, counter );
        e_send_uart1_char(buffer, strlen(buffer)); while(e_uart1_sending());
        
    }
    
    
}




