#include <SoftwareSerial.h>
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x27,16,2);
const byte pir = 7;
const byte rxPin = 2;
const byte txPin = 3;
const byte rxPin2 = 4;
const byte txPin2 = 5;
SoftwareSerial mySerial (rxPin, txPin);
SoftwareSerial mySerial2 (rxPin2, txPin2);
bool presenca = false;
String temp="";
float tmp=0;

void setup() {
  lcd.init();                  
  lcd.backlight();
  pinMode(pir, INPUT);
  Serial.begin(9600);    
  mySerial.begin(9600);
  mySerial2.begin(9600);
}

void loop() {
  lcd.setCursor(0,0);
  lcd.print("Temperatura:");
  lcd.setCursor(12,0);
  lcd.print(tmp);
  lcd.setCursor(14,0);
  lcd.print("o");
  lcd.setCursor(15,0);
  lcd.print("C");
  presenca = digitalRead(pir);
  digitalWrite(13, presenca);
  
   if (mySerial.available() > 0) {
        mySerial.write(presenca);
   }
   
   if (mySerial2.available() > 0) {
        temp = mySerial2.readStringUntil('\n');
        if( temp!="0")
          tmp = temp.toInt();
        delay(100);
    }
        Serial.println(temp);
}