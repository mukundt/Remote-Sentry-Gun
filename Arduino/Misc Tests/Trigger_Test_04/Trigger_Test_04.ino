#define PIN_TRIGGER 7
#define PIN_POWER 8
#define PIN_SAFETY_A 9     // blue
#define PIN_SAFETY_B 10    // green

/* Firing Mode Codes:
   A   B   Mode
  -----------------
   1   1   Safe
   1   0   Semi-automatic
   0   0   Burst
   0   1   Full automatic
   
   Trigger: 0 pulled, 1 released
   
   Power: 0 pressed, 1 released
*/

void setup() {
  
  pinMode(PIN_POWER, OUTPUT);
  pinMode(PIN_TRIGGER, OUTPUT);
  pinMode(PIN_SAFETY_A, OUTPUT);
  pinMode(PIN_SAFETY_B, OUTPUT);
  
  digitalWrite(PIN_TRIGGER, HIGH);
  digitalWrite(PIN_SAFETY_A, HIGH);
  digitalWrite(PIN_SAFETY_B, HIGH);
  digitalWrite(PIN_POWER, LOW);
  
  safety_on();
  delay(3000);
  power_toggle();
  delay(1000);
  safety_off();
  delay(1000);
  fire(10);
  delay(1000);
  fire(10);
  delay(1000);
  fire(10);
  delay(1000);
  safety_on();
  delay(1000);
  power_toggle();
  
  
}

void loop() {

}

void power_toggle() {
  digitalWrite(PIN_POWER, HIGH);
  delay(3000);
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

void fire(int num_shots) {
  for (int i = 0; i < num_shots; i++) {
    digitalWrite(PIN_TRIGGER, LOW);
    delay(50);
    digitalWrite(PIN_TRIGGER, HIGH);
    delay(50);  
  }
}

