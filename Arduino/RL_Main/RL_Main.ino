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

boolean pan_left, pan_right;
boolean tilt_up, tilt_down;
boolean trigger_on;

boolean gun_armed = false;

void setup() {
  pinMode(PIN_POWER, OUTPUT);
  pinMode(PIN_SAFETY_A, OUTPUT);
  pinMode(PIN_SAFETY_B, OUTPUT);
  
  digitalWrite(PIN_POWER, LOW);
  safety_on();
  
  pan.enable();
  tilt.enable();
 
  pan_left = pan_right = tilt_up = tilt_down = trigger_on = false; 
  
  ble_begin();

  //Temporary serial code - comment when done
  Serial.begin(57600);
}

void loop() {
  while (ble_available())
   //Temporary serial code - comment when done
  //while (Serial.available())
  {
    char command = (char)ble_read();
    delay(100);
    char velocity = '0';
    Serial.println(command);
    //Serial.println(command);
    switch (command)
    {
      case 'q':
        velocity = (char)ble_read();
        pan_right = true;
        pan_left = false;
        tilt_up = false;
        tilt_down = false;
        break;
      case 'w':
        velocity = (char)ble_read();
        pan_right = true;
        pan_left = false;
        tilt_up = true;
        tilt_down = false;
        break;
      case 'e':
        velocity = (char)ble_read();
        pan_right = false;
        pan_left = false;
        tilt_up = true;
        tilt_down = false;
        break;
      case 'r':
        velocity = (char)ble_read();
        pan_right = false;
        pan_left = true;
        tilt_up = true;
        tilt_down = false;
        break;
      case 't':
        velocity = (char)ble_read();
        pan_right = false;
        pan_left = true;
        tilt_up = false;
        tilt_down = false;
        break;
      case 'y':
        velocity = (char)ble_read();
        pan_right = false;
        pan_left = true;
        tilt_up = false;
        tilt_down = true;
        break;
      case 'u':
        velocity = (char)ble_read();
        pan_right = false;
        pan_left = false;
        tilt_up = false;
        tilt_down = true;
        break;
      case 'i':
        velocity = (char)ble_read();
        pan_right = true;
        pan_left = false;
        tilt_up = false;
        tilt_down = true;
        break;
      case 'p': 
        velocity = (char)ble_read();
        pan_left = false;
        pan_right = false;
        tilt_up = false;
        tilt_down = false;
        break;
      case 'f':
        trigger_on = true;
        break;
      case 'n':
        trigger_on = false;
        break;
      case 'k':
        if (!gun_armed) {
          power_toggle();
          delay(1000);
          safety_off();
          delay(1000);
          gun_armed = true;
        }
        break;
      case 'l':
        if (gun_armed) {
          safety_on();
          delay(1000);
          power_toggle();
          delay(1000);
          gun_armed = false;
        }
        break;
      default: 
        break;
    }
//    Serial.println(velocity);
  }
  
  //sends relevant command every clock cycle
  if (pan_left) pan.move_relative(step_amount);
  if (pan_right) pan.move_relative(-step_amount);
  if (tilt_up) tilt.move_relative(step_amount);
  if (tilt_down) tilt.move_relative(-step_amount);
  if (trigger_on) trigger.single_shot();

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
