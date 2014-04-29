#define PIN_TRIGGER 7
#define PIN_POWER 8
#define PIN_SAFETY_A 9     // blue
#define PIN_SAFETY_B 10    // green

void setup() {
  pinMode(PIN_TRIGGER, INPUT);
  pinMode(PIN_POWER, INPUT);
  pinMode(PIN_SAFETY_A, INPUT);
  pinMode(PIN_SAFETY_B, INPUT);
  Serial.begin(9600);
}

void loop() {
  Serial.print("Trigger: ");
  Serial.print(digitalRead(PIN_TRIGGER));
  Serial.print("     Power: ");
  Serial.print(digitalRead(PIN_POWER));
  Serial.print("     Safety A: ");
  Serial.print(digitalRead(PIN_SAFETY_A));
  Serial.print("     Safety B: ");
  Serial.println(digitalRead(PIN_SAFETY_B));
}


/* Safety Codes:
   A   B   Mode
  -----------------
   1   1   Safe
   1   0   Semi-automatic
   0   0   Burst
   0   1   Full automatic
