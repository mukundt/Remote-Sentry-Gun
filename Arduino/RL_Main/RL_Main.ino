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
#include "RL_Trigger.h"

#define pan_step_pin 2
#define pan_direction_pin 3
#define pan_enable_pin 4

#define tilt_step_pin 5
#define tilt_direction_pin 6
#define tilt_enable_pin 7

#define trigger_pin 14

#define step_amount 10

Stepper pan(pan_step_pin, pan_direction_pin, pan_enable_pin);
Stepper tilt(tilt_step_pin, tilt_direction_pin, tilt_enable_pin);
Trigger trigger(trigger_pin);

boolean pan_left, pan_right;
boolean tilt_up, tilt_down;
boolean trigger_on;

void setup() {
   
  pan.enable();
  tilt.enable();
 
  pan_left = pan_right = tilt_up = tilt_down = trigger_on = false; 
  
  ble_begin();
  
  //Temporary serial code - comment when done
  //Serial.begin(57600);
}

void loop() {
  while (ble_available())
   //Temporary serial code - comment when done
  //while (Serial.available())
  {
    char command = (char)ble_read();
    //Serial.println(command);
    switch (command)
    {
      case 'a': 
        pan_left = true; 
        break;
      case 'd': 
        pan_right = true;
        break;
      case 'p': 
        pan_left = pan_right = false;
        break;
      case 'w': 
        tilt_up = true;
        break;
      case 's': 
        tilt_down = true;
        break;
      case 't': 
        tilt_up = tilt_down = false;
        break;
      case 'f':
        trigger_on = true;
        break;
      case 'n':
        trigger_on = false;
        break;
      default: 
        break;
    }
  }
  
  //sends relevant command every clock cycle
  if (pan_left) pan.move_relative(step_amount);
  else if (pan_right) pan.move_relative(-step_amount);
  else if (tilt_up) tilt.move_relative(step_amount);
  else if (tilt_down) tilt.move_relative(-step_amount);
  else if (trigger_on) trigger.single_shot();

  ble_do_events();
}
