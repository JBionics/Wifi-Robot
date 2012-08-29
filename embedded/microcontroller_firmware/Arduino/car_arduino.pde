/*******************************************************************
; Function:  Wifi Robot Arduino Firmware
; Filename:  car_arduino.c
; Author:    Jon Bennett
; Website:   www.jbprojects.net/projects/wifirobot
;*******************************************************************/

#define DEBUG 0
#define WAIT_FOR_START 1

unsigned char incomingByte = 0;
unsigned long loop_count = 0;
unsigned char horn = 32;
unsigned char redLED = 64;
unsigned char greenLED = 128;

unsigned char forward = 1;
unsigned char backward = 2;
unsigned char left = 4;
unsigned char right = 8;

unsigned char PORTB_val;
unsigned char PORTD_val;

unsigned char in_char = 0;

void setup() 
{
//PORTD = digital IO 0-7
//horn, redLED, greenLED

  pinMode(5, OUTPUT);      // sets the digital pin as output
  pinMode(6, OUTPUT);      // sets the digital pin as output
  pinMode(7, OUTPUT);      // sets the digital pin as output

//PORTB = digital IO 8 - 13  
//right, left, backwards, forward

  pinMode(8, OUTPUT);      // sets the digital pin as output
  pinMode(9, OUTPUT);      // sets the digital pin as output
  pinMode(10, OUTPUT);     // sets the digital pin as output
  pinMode(11, OUTPUT);     // sets the digital pin as output
  
  Serial.begin(9600);      // set up Serial library at 9600 bps
  
  PORTD = redLED;		   // turn on the red LED
  
  #if DEBUG
	flash_led(3,500);
  #endif
  
  wait_for_start();  //Waits for startup message from router serial port
					 //continues after receiving it.
}


void flash_led(unsigned int count, unsigned int rate)
{
// debug routine that flashes an LED

 int n_count = 0;

 while (n_count < count)
 {
   n_count++;
   digitalWrite(13, HIGH);       // sets the LED on
   delay(rate);                  // waits for a bit
   digitalWrite(13, LOW);        // sets the LED off
   delay(rate);                  // waits for a bit
 }
}

char get_char()
{
//Function that waits for a character from the serial port
//If none are received, it returns 0.
//The timeout is so that if the router stops sending data to the microcontroller,
//the micrcontroller will stop driving the car, rather than just going forever with
//the last command.  Timeout is around 250mS.

  while (loop_count < 30000)
  {
    loop_count++;

    if (Serial.available() > 0)
    {
      incomingByte = Serial.read();
      loop_count = 0;
      return incomingByte; 
    }
  }  
  
  loop_count = 0;
  
  #if DEBUG
        Serial.print('X', BYTE);
  #endif
  
  return 0; 
}

unsigned char wait_for_start()
{
//Waits for startup message from router serial port
#if WAIT_FOR_START

  #if DEBUG
    Serial.println("Waiting...");
  #endif

  while(1)
  {
    if (get_char() == 'j' && get_char() == 'b' && get_char() == 'p' && get_char() == 'r' && get_char() == 'o') 
  { 
    
  #if DEBUG
      Serial.print("Passcode Accepted");
  #endif

      return 0; 
    }
  }
#endif
}

void loop()                       
{  
//Function that processes input from serial port and drives the car based
//on that input.

  in_char = get_char();
  
  //Split byte received in to upper and lower halves.
  PORTB_val = in_char & 0x0F;
  PORTD_val = in_char & 0xF0;
  
  //Make sure the greenLED is turned on now.
  if ((PORTD_val & greenLED) == 0)
  {
    PORTD_val = PORTD_val + greenLED;          
  }
  
  //The following IF statements are sanity checks to make sure that FORWARD and BACKWARD cannot be on at the same time
  //and that LEFT and RIGHT can't be on at the same time.
  if ((PORTB_val & (left + right)) == (left + right))
  {    
    PORTB_val = PORTB_val - right;    
  }
  
  if ((PORTB_val & (forward + backward)) == (forward + backward))
  {
    PORTB_val = PORTB_val - backward; 
  }

  //Write the processed values to the ports.
  PORTD = PORTD_val;
  PORTB = PORTB_val;

  #if DEBUG
    Serial.print(PORTD, HEX);
    Serial.print(PORTB, HEX);
  #endif

}
