#define PIN_STEP 2
#define PIN_DIRECTION 3
#define PIN_ENABLE 4

#define STEP_DELAY_uS 2000  // includes high dwell time 
// (2000 uS  =>  about 2.5 rotations per second: after gearing, gun moves 150 deg in 1 sec)
#define STEP_DWELL_uS 100  // high dwell time

void setup() {
  pinMode(PIN_STEP, OUTPUT);
  digitalWrite(PIN_STEP, LOW);
  pinMode(PIN_DIRECTION, OUTPUT);
  digitalWrite(PIN_DIRECTION, LOW);
  pinMode(PIN_ENABLE, OUTPUT);
  off();
}

void loop() {
  off();
  delay(2000);
  on();
  delay(2000); 
  move(true, 200);
}
  
void on() {
  // Enables the motor, which puts full holding torque on the output shaft.
  // CAUTION: leaving a motor on for too long can cause it to overheat.
  digitalWrite(PIN_ENABLE, LOW);
}

void off() {
  digitalWrite(PIN_ENABLE, HIGH); // this pin has inverse logic
}

void move(boolean clockwise, int total_steps) {
  // Moves the motor total_steps.
  // Set clockwise = true to move clockwise, clockwise = false to move counter-clockwise.
  // This function blocks until the motion is completed.
  // If the motor was previously off, this function turns it on. In all cases, the function leaves the motor on.
  on();
  digitalWrite(PIN_DIRECTION, clockwise);
  for(int step_number = 0; step_number < total_steps; step_number++) {
    digitalWrite(PIN_STEP, HIGH);
    delayMicroseconds(STEP_DWELL_uS);
    digitalWrite(PIN_STEP, LOW);
    delayMicroseconds(STEP_DELAY_uS - STEP_DWELL_uS);
  }
}

