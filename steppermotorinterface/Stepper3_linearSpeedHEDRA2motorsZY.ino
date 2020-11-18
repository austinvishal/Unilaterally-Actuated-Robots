
//#define DIR_PIN          7   // in this code first it winds, then unwinds for z
//#define STEP_PIN         4
#define ENABLE_PIN       8


#define Y_DIR_PIN          6  // in this code first it unwinds, then winds for y
#define Y_STEP_PIN         3
//#define Y_ENABLE_PIN       8

#define Z_DIR_PIN          7 // in this code first it winds, then unwinds for z
#define Z_STEP_PIN         4
//#define Z_ENABLE_PIN       8

void setup() {
//  pinMode(STEP_PIN,   OUTPUT);
//  pinMode(DIR_PIN,    OUTPUT);
//  pinMode(ENABLE_PIN, OUTPUT);
  //pinMode(X_ENABLE_PIN, OUTPUT);


  pinMode(Z_STEP_PIN,   OUTPUT);
  pinMode(Z_DIR_PIN,    OUTPUT);
  //pinMode(Z_ENABLE_PIN, OUTPUT);
  
  pinMode(Y_STEP_PIN,   OUTPUT);
  pinMode(Y_DIR_PIN,    OUTPUT);
 // pinMode(Y_ENABLE_PIN, OUTPUT);

  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, LOW);
}

//#define STEPS 400  // 400 array values
#define STEPS 600  // 400 array values

void constantAccel() {
  int delays[STEPS];  // array with 400 values array of integers
  float angle = 1;
  //float accel = 0.01;
  float accel = 0.0025;
  float c0 = 2000 * sqrt( 2 * angle / accel ) * 0.67703;
  float lastDelay = 0;
  //int highSpeed = 100;
  int highSpeed = 200;
  for (int i = 0; i < STEPS; i++) {
    float d = c0;
    if ( i > 0 )
      d = lastDelay - (2 * lastDelay) / (4 * i + 1);
    if ( d < highSpeed )
      d = highSpeed;
    delays[i] = d;
    lastDelay = d;
  }

  // use delays from the array, forward
     // use delays from the array, forward
  for (int i = 0; i < STEPS; i++) {
    digitalWrite(Z_STEP_PIN, HIGH);
    delayMicroseconds( delays[i] );
    digitalWrite(Z_STEP_PIN, LOW);
  }

  // use delays from the array, backward
  for (int i = 0; i < STEPS; i++) {
    digitalWrite(Z_STEP_PIN, HIGH);
    delayMicroseconds( delays[STEPS-i-1] );
   digitalWrite(Z_STEP_PIN, LOW);
  }
    // use delays from the array, forward
  for (int i = 0; i < STEPS; i++) {
    digitalWrite(Y_STEP_PIN, HIGH);
    delayMicroseconds( delays[i] );
   digitalWrite(Y_STEP_PIN, LOW);
  }

  // use delays from the array, backward
  for (int i = 0; i < STEPS; i++) {
    digitalWrite(Y_STEP_PIN, HIGH);
    delayMicroseconds( delays[STEPS-i-1] );
    digitalWrite(Y_STEP_PIN, LOW);
  }

 
}

void loop() {

  digitalWrite(Z_DIR_PIN, LOW);
  constantAccel();
  digitalWrite(Z_DIR_PIN, LOW);
  constantAccel();
  digitalWrite(Y_DIR_PIN, LOW);
  constantAccel();
  digitalWrite(Y_DIR_PIN, LOW);
  constantAccel();


  while (true);
}
