#include <RL_Trigger.h>

#define PIN_TRIGGER 8

Trigger trigger(PIN_TRIGGER);

void setup() {
  Serial.begin(9600);
  trigger.set_delay(45);
  trigger.set_dwell(45);
}

void loop() {
  int num_shots = 0;
  while (Serial.available() > 0) {
    byte data = Serial.read();
    num_shots += (data - 48);
    Serial.print("Firing ");
    Serial.print(num_shots);
    Serial.print(" shots\n");
  }
  if (num_shots > 1) {
    trigger.burst(num_shots);
  } else if (num_shots == 1) {
    trigger.single_shot();
  }
}
