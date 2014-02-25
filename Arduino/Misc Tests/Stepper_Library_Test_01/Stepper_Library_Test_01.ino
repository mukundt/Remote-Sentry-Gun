#include <RL_Stepper.h>

#define PIN_PAN_STP 2
#define PIN_PAN_DIR 3
#define PIN_PAN_EN 4

#define PIN_TILT_STP 5
#define PIN_TILT_DIR 6
#define PIN_TILT_EN 7

Stepper pan(PIN_PAN_STP, PIN_PAN_DIR, PIN_PAN_EN);
Stepper tilt(PIN_TILT_STP, PIN_TILT_DIR, PIN_TILT_EN);

void setup() {
  pan.enable();
  tilt.disable();
}

void loop() {
  pan.move_relative(1000);
  pan.set_delay(5.0);
  pan.move_relative(1000);
  pan.set_delay(2.0);
  
}

