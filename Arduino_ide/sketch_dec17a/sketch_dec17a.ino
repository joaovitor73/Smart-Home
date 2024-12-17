#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>
#include <DHT.h>

#define WIFI_SSID "A"
#define WIFI_PASSWORD "12345678"
#define API_KEY "AIzaSyB2hyLRaBR3ZVqmnHYkvXN1IvZV_NJusFc"
#define USER_EMAIL "adm@gmail.com"
#define USER_PASSWORD "admin123"
#define DATABASE_URL "https://smart-home-876c0-default-rtdb.firebaseio.com/"
#define DHTTYPE DHT22

FirebaseApp app;
DefaultNetwork network;
WiFiClientSecure ssl_client;
using AsyncClient = AsyncClientClass;
RealtimeDatabase Database;

void asyncCB(AsyncResult &aResult);
UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD, 3000);
AsyncClient aClient(ssl_client, getNetwork(network));

const byte ledSala = 2;
const byte ledCozinha = 18;
const byte ledBanheiro = 21;
const byte DHTPIN = 5;
const byte redLedRGB = 25;
const byte greenLedRGB = 33;
const byte blueLedRGB = 32;
const byte pinEn1 = 19;
const byte motorQuartoA1 = 4;
const byte motorQuartoB1 = 15;

DHT dht(DHTPIN, DHTTYPE);

enum Comodo {
    SALA,
    QUARTO,
    COZINHA,
    BANHEIRO
};

enum Sensor{
  PRESENCA,
  UMIDADE,
  LUZ, 
  TEMPERATURA,
  LED, 
  LCD,
  MOTOR,
  DISTANCIA,
  LED_RGB
};

void setup() {
    Serial.begin(115200);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(300);
    }
    Serial.println("Initializing app...");
    ssl_client.setInsecure();
    initializeApp(aClient, app, getAuth(user_auth), asyncCB, "authTask");
    app.getApp<RealtimeDatabase>(Database);
    Database.url(DATABASE_URL);

    pinMode(ledSala, OUTPUT); 
    pinMode(ledCozinha, OUTPUT);  
    pinMode(ledBanheiro, OUTPUT);
    dht.begin();
    pinMode(redLedRGB, OUTPUT);
    pinMode(greenLedRGB, OUTPUT);
    pinMode(blueLedRGB, OUTPUT);
    pinMode(motorQuartoA1, OUTPUT);
    pinMode(motorQuartoB1, OUTPUT);
    pinMode(pinEn1, OUTPUT);

    Database.get(aClient, "/smart_home/json", asyncCB, true);
}

void loop() {
    app.loop();
    Database.loop();
}

void asyncCB(AsyncResult &aResult) {  
    if (aResult.available()) {
      RealtimeDatabaseResult &RTDB = aResult.to<RealtimeDatabaseResult>();

      if (RTDB.isStream()) {
          String path = RTDB.dataPath();
          String data = RTDB.to<String>();
          String comodo = "";
          String sensor = "";

          int startIdx = path.indexOf("/comodos/") + 9; 
          int endIdx = path.indexOf("/", startIdx);  
          comodo = path.substring(startIdx, endIdx);  
          startIdx = path.indexOf("/sensores/") + 10;  
          endIdx = path.indexOf("/", startIdx);  
          sensor = path.substring(startIdx, endIdx);
          Serial.println(data);
          int valor = data.toInt();
          if(sensor != "luz" && sensor != "presenca" && sensor != "umidade" && sensor != "temperatura"){
                if(sensor == "led_rgb"){
                  int startIdx = path.lastIndexOf("/") + 1; 
                  String value = path.substring(startIdx); 
                  if(value == "r"){
                    analogWrite(redLedRGB, valor);
                    Serial.println("r");
                  }else if(value == "b"){
                      analogWrite(greenLedRGB, valor);
                       Serial.println("g");
                  }else{
                      analogWrite(blueLedRGB, valor);
                       Serial.println("b");
                  }
                }else{
                    swhitchComfortable(comodo, valor, sensor);
                }
          }
      }
  }
}


void swhitchComfortable(String nomeComodo, int ultimoValor, String tipoSensor){
  Comodo comodo = getComodoEnum(nomeComodo);
  Sensor sensor = getSensoresEnum(tipoSensor);
  switch(comodo){
    case 3: updateBanheiro(ultimoValor, sensor, tipoSensor, nomeComodo);
      break;
    case 2: updateCozinha(ultimoValor, sensor,  tipoSensor, nomeComodo);
      break;
    case 1: updateQuarto(ultimoValor, sensor, tipoSensor, nomeComodo);
      break;
    case 0: updateSala(ultimoValor, sensor,  tipoSensor, nomeComodo);
      break;
  }
}

void updateBanheiro(int valor, Sensor sensor, String tipoSensor, String nomeComodo){
   switch(sensor){ 
    case 4: digitalWrite(ledBanheiro, valor);
      break;
  }
}

void updateCozinha(int valor, Sensor sensor, String tipoSensor, String nomeComodo){
   switch(sensor){
    case 4: digitalWrite(ledCozinha, valor);
      break;
  }
}

void updateQuarto(int valor, Sensor sensor, String tipoSensor, String nomeComodo){
   switch(sensor){
    case 8:
    break;
    case 7: 
      break;
    case 6: 
      analogWrite(pinEn1, valor);
      digitalWrite(motorQuartoA1, HIGH);
      digitalWrite(motorQuartoB1, LOW);
      break;
    case 5: 
      break;
  }
}

void updateSala(int valor, Sensor sensor, String tipoSensor, String nomeComodo){
   switch(sensor){
    case 4: digitalWrite(ledSala, valor);
      break;
  }
}

Comodo getComodoEnum(String nomeComodo) {
    if (nomeComodo == "sala") return SALA;
    if (nomeComodo == "quarto") return QUARTO;
    if (nomeComodo == "cozinha") return COZINHA;
    if (nomeComodo == "banheiro") return BANHEIRO;
}

Sensor getSensoresEnum(String sensor) {
    if (sensor == "umidade") return UMIDADE;
    if (sensor == "presenca") return PRESENCA;
    if (sensor == "distancia") return DISTANCIA;
    if (sensor == "led") return LED;
    if (sensor == "motor") return MOTOR;
    if (sensor == "lcd") return LCD;
    if (sensor == "luz") return LUZ;
    if (sensor == "temperatura") return TEMPERATURA;
    if (sensor == "led_rgb") return LED_RGB;
}