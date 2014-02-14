//
//  MotorControl.ino
//  Remote-Sentry-Gun
//
//  Created by Mukund Tibrewala on 13/2/14.
//  www.mukundt.com
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>
#include "RL_Stepper.h"

#define pan_step_pin 2
#define pan_direction_pin 3
#define pan_enable_pin 4

#define tilt_step_pin 5
#define tilt_direction_pin 6
#define tilt_enable_pin 7

#define step_amount 1

Stepper pan(pan_step_pin, pan_enable_pin, pan_direction_pin);
Stepper tilt(tilt_step_pin, tilt_enable_pin, tilt_direction_pin);
boolean pan_left, pan_right, tilt_up, tilt_down;

void setup() {
   
  pan.enable();
  tilt.enable();
 
  pan_left = pan_right = tilt_up = tilt_down = false; 
  /*Bluetooth code - uncomment when ready
  
  ble_begin();
  
  */
  
  //Temporary serial code - comment when done
  Serial.begin(57600);
}

void loop() {
  /*Bluetooth code - uncomment when ready
  
  while (ble_available())
 
  */

  //Temporary serial code - comment when done
  while (Serial.available())
  {
    byte command = Serial.read(); //Change this to ble_read();
    
    switch (command)
    {
      case 0x01: 
        pan_left = true; 
        break;
      case 0x02: 
        pan_right = true;
        break;
      case 0x03: 
        pan_left = pan_right = false;
        break;
      case 0x04: 
        tilt_up = true;
        break;
      case 0x05: 
        tilt_down = true;
        break;
      case 0x06: 
        tilt_up = tilt_down = false;
        break;
      default: 
        break;
    }
  }
  
  if (pan_left) {pan.move_absolute(step_amount);}
  else if (pan_right) {pan.move_absolute(-step_amount);}
  else if (tilt_up) {tilt.move_absolute(step_amount);}
  else if (tilt_down) {pan.move_absolute(-step_amount);}

}
