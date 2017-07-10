//#define FCY 28000000ULL
//#include <C:\Program Files (x86)\Microchip\MPLAB C30\support\h\libpic30.h>
#include "C:\Program Files (x86)\Microchip\MPLAB C30\support\h\p30F6014A.h"

#include "stdio.h"
#include "string.h"
#include "math.h"
#include <stdlib.h>
#include <time.h>

#include <codec/e_sound.h>
#include <motor_led/e_init_port.h>
#include <motor_led/e_epuck_ports.h>
#include <motor_led/advance_one_timer/e_led.h>
#include <motor_led/advance_one_timer/e_motors.h>
#include <motor_led/advance_one_timer/e_agenda.h>
//#include <camera/fast_2_timer/e_poxxxx.h>
#include <uart/e_uart_char.h>
#include <a_d/advance_ad_scan/e_ad_conv.h>
#include <a_d/advance_ad_scan/e_prox.h>
//#include <a_d/advance_ad_scan/e_acc.h>
//#include <a_d/advance_ad_scan/e_micro.h>
#include <bluetooth/e_bluetooth.h>
//#include <acc_gyro/e_lsm330.h>
#include <I2C/e_I2C_protocol.h>
#include "util.h"
#include <utility/utility.h>

#include "escape.h"

/* selector on normal extension*/

#define SELECTOR0 _RG6

#define SELECTOR1 _RG7

#define SELECTOR2 _RG8

#define SELECTOR3 _RG9


#include "memory.h"
char buffer[BUFFER_SIZE];
extern int selector;
char c;

//#define PI 3.14159265358979

#define uart1_send_static_text(msg) { e_send_uart1_char(msg,sizeof(msg)-1); while(e_uart1_sending()); }

int main() {
	//SLEEP(); while(1);

	//static int version, i, r=-1, g=-1, b=-1;
	//char command[20];
	//char response[50];

	//system initialization
	e_init_port();    // configure port pins      
	e_start_agendas_processing();
        e_init_motors();
	e_init_uart1();   // initialize UART to 115200 Kbaud
	e_init_ad_scan(ALL_ADC);
	//e_init_ad_scan();
	//Reset if Power on (some problem for few robots)
	if (RCONbits.POR) {
		RCONbits.POR=0;
		__asm__ volatile ("reset");
	}
        
	// Decide upon program
	selector=getselector();
	sprintf(buffer, "Selector pos %d\r\n", selector);
	e_send_uart1_char(buffer, strlen(buffer));	while(e_uart1_sending());
    
    //uart1_send_static_text(buffer)
    
    switch(selector){
        case 1:
            run_escape();
        case 2:
//            run_ground_matlab();
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 13:
        case 14:
        case 15: 
        case 9:
        case 10:
        case 11:
        case 12:
            run_escape_dummy();
                    
          
    }
            
	return 0;
}

