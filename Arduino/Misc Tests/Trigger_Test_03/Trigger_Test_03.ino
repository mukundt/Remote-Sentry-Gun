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
  
  digitalWrite(PIN_POWER, HIGH);
  digitalWrite(PIN_TRIGGER, HIGH);
  digitalWrite(PIN_SAFETY_A, HIGH);
  digitalWrite(PIN_SAFETY_B, HIGH);
  
  Serial.begin(9600);
  Serial.println("Setup complete!");
  delay(3000);
//  Serial.println("Pressing power button...");
//  digitalWrite(PIN_POWER, LOW);
//  Serial.println("Holding power button for three seconds...");
//  delay(3000);
//  Serial.println("Releasing power button...");
//  digitalWrite(PIN_POWER, HIGH);
//  delay(500);
//  Serial.println("Gun powered on!");
//  delay(500);
  Serial.println("Switch to semi-auto mode");
  digitalWrite(PIN_SAFETY_A, HIGH);
  digitalWrite(PIN_SAFETY_B, LOW);
  delay(3000);
  Serial.println("Switch to burst mode");
  digitalWrite(PIN_SAFETY_A, LOW);
  digitalWrite(PIN_SAFETY_B, LOW);
  delay(3000);
  Serial.println("Switch to full auto mode");
  digitalWrite(PIN_SAFETY_A, LOW);
  digitalWrite(PIN_SAFETY_B, HIGH);
  delay(3000);
  Serial.println("Fire three test shots");
  digitalWrite(PIN_TRIGGER, LOW);
  delay(150);
  digitalWrite(PIN_TRIGGER, HIGH);
  delay(150);  
  digitalWrite(PIN_TRIGGER, LOW);
  delay(150);
  digitalWrite(PIN_TRIGGER, HIGH);
  delay(150);  
  digitalWrite(PIN_TRIGGER, LOW);
  delay(150);
  digitalWrite(PIN_TRIGGER, HIGH);
  delay(150);  
  
  
  
}

void loop() {
//  Serial.print("Trigger: ");
//  Serial.print(digitalRead(PIN_TRIGGER));
//  Serial.print("     Power: ");
//  Serial.print(digitalRead(PIN_POWER));
//  Serial.print("     Safety A: ");
//  Serial.print(digitalRead(PIN_SAFETY_A));
//  Serial.print("     Safety B: ");
//  Serial.println(digitalRead(PIN_SAFETY_B));
}

void power_toggle() {
  digitalWrite(PIN_POWER, LOW);
  delay(3000);
  digitalWrite(PIN_POWER, HIGH);
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
    delay(150);
    digitalWrite(PIN_TRIGGER, HIGH);
    delay(150);  
  }
}

