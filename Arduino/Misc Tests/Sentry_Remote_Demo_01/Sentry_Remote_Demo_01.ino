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

#define pan_step_pin 14
#define pan_direction_pin 15
#define pan_enable_pin 16

#define tilt_step_pin 17
#define tilt_direction_pin 18
#define tilt_enable_pin 19

#define trigger_pin 7   // purple

#define PIN_POWER 4    // red & yellow
#define PIN_SAFETY_A 5 // blue
#define PIN_SAFETY_B 6 // green

#define step_amount 1

Stepper pan(pan_step_pin, pan_direction_pin, pan_enable_pin);
Stepper tilt(tilt_step_pin, tilt_direction_pin, tilt_enable_pin);
Trigger trigger(trigger_pin);

boolean gun_armed = false;

unsigned long start_time = millis();

void setup() {
  pinMode(PIN_POWER, OUTPUT);
  pinMode(PIN_SAFETY_A, OUTPUT);
  pinMode(PIN_SAFETY_B, OUTPUT);
  
  digitalWrite(PIN_POWER, LOW);
  safety_on();
  
  pan.enable();
  tilt.enable();
 
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
      case 'k':
        gun_armed = true;
        tilt.move_absolute(0);
        start_time = millis();
        break;
      case 'l':
        gun_armed = false;
        tilt.move_absolute(0);
        start_time = millis();
        break;
      default: 
        break;
    }
  }
  
  if (gun_armed) {
    if ((millis()-start_time) % 12000 < 3000 || (millis()-start_time) % 12000 >= 9000) {
      tilt.move_relative(step_amount);
    }else{
      tilt.move_relative(-step_amount);
    }
  }
  
  ble_do_events();
}

void power_toggle() {
  digitalWrite(PIN_POWER, HIGH);
  delay(4000);
  digitalWrite(PIN_POWER, LOW);
  delay(500);
}

void safety_off() {
  digitalWrite(PIN_SAFETY_A, HIGH);
  digitalWrite(PIN_SAFETY_B, LOW);
}

void safety_on() {
  digitalWrite(PIN_SAFETY_A, HIGH);
  digitalWrite(PIN_SAFETY_B, HIGH);
}
