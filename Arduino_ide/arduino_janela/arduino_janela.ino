#include <SoftwareSerial.h>
#include <Servo.h>
const byte rxPin = 2;
const byte txPin = 3;
SoftwareSerial mySerial (rxPin, txPin);
String tempString;
Servo meuServo; 
char estado = '0';
void setup() {
  meuServo.attach(9);
  mySerial.begin(9600);
  Serial.begin(9600);
  meuServo.write(179);
}

void loop() {
  // put your main code here, to run repeatedly:
  tempString = "";
  if(mySerial.available()){
  char data = mySerial.read();
    Serial.print(data);

    Serial.println(tempString);
    if(data == '1'){
      meuServo.write(0);
    }else if(data == '0'){
      meuServo.write(179);
    }
    }

}
