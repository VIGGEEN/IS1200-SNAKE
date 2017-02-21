/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}


/* Lab-specific initialization goes here */
void labinit(void)
{
	//INITIALIZE PORT E(0xbf886100) AS OUTPUT AT BITS 0-7
	volatile int* initPORTE = 0xbf886100;
	*initPORTE = (*initPORTE & ~0xFF);

	//INITIALIZE PORTD AS INPUT AT BITS 5-11
	TRISD = 0x7F0;

	// Stop timer and clear control register,
	T2CON = 0x0; 

	// Clear timer register
	TMR2 = 0x0; 
	// Initialize period register
	PR2 = 0x7FFF; 

	// Start the timer and set prescaling to 256
	T2CONSET = 0x8070;

	return;
}

void displaytick()
{
	//Move the value of mytime to PORT E output
	volatile int* outputPORTE = 0xbf886110;
	*outputPORTE = mytime;
}

/* This function is called repetitively from the main program */
int timeCount = 0;
void labwork( void )
{
  display_image(96, icon);
  displaytick();

  //Get the value of buttons
  int btns = getbtns();
  if (btns != 0)
  {
	  //Get the value of switches
	 int sw = getsw();

	 //volatile int* outputPORTE = 0xbf886110;

	 char* test = &mytime;
	
	 if (btns == 4)
	 {
		 ++test;
		 //DIG1
		 *test = (sw << 4 | *test & 0xF);
	 }
	 else if (btns == 2)
	 {
		 ++test;
		 //DIG2
		 *test = (sw | *test & 0xF0);
	 }
	 else if (btns == 1)
	 {
		 //DIG3
		 *test = (sw << 4 | (*test & 0xF));
	 }
	 else if (btns > 4)
	 {
		 //DIG3
		 *test = (sw << 4 | (*test & 0xF));
		 ++test;
		 //DIG1
		 *test = (sw << 4 | *test & 0xF);
		 //DIG2
		 *test = (sw | *test & 0xF0);
	 }
  }

  //If the timeoutflag is set by the timer, execute our logic
  if (IFS(0) & 0x00000100)
  {
	  //Reset the flag
	  //IFSCLR(0) = 0x00000100;

	  //Add to our counter
	  timeCount++;
	  
	  //100MS*10 = 1 second
	  if (timeCount >= 10)
	  {
		  //Update values
		  time2string(textstring, mytime);
		  display_string(3, textstring);
		  display_update();
		  tick(&mytime);

		  //Reset counter
		  timeCount = 0;
	  }
  }
}
