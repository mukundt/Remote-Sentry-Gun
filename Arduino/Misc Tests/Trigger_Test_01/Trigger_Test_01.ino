#define PIN_TRIGGER 8
#define PIN_STATUS 13

void setup() {
  pinMode(PIN_TRIGGER, OUTPUT);
  pinMode(PIN_STATUS, OUTPUT);
  digitalWrite(PIN_TRIGGER, HIGH);  
  digitalWrite(PIN_STATUS, HIGH);  
}

void loop() {
  fire();
  delay(50);
}

void fire() {
  digitalWrite(PIN_TRIGGER, LOW);  // inverse logic
  digitalWrite(PIN_STATUS, LOW);  
  delay(50);
  digitalWrite(PIN_TRIGGER, HIGH);  
  digitalWrite(PIN_STATUS, HIGH); 
}
