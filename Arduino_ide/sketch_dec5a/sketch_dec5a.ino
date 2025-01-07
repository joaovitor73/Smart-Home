#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include <DHT.h>

#define RXD1 13 // GPIO 13 como RX do ESP32
#define TXD1 14 // GPIO 14 como TX do ESP32

// #define RXD2 16 // GPIO 16 como RX do ESP32
// #define TXD2 17 // GPIO 17 como TX do ESP32
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
const byte ledQuarto = 19;
const byte ledBanheiro = 21;
const byte DHTPIN_Cozinha = 5;
const byte DHTPIN_Quarto = 18; // mudar depois o pino
const byte redLedRGB = 25;
const byte greenLedRGB = 33;
const byte blueLedRGB = 32;
const byte pinEn1 = 23;
const byte motorQuartoA1 = 4;
const byte motorQuartoB1 = 15;

const int pinoPIR = 15;
const int LDR_PIN_Quarto = 34; 
const int LDR_PIN_Sala = 35; 
const int LDR_PIN_Banheiro = 19; 
const int LDR_PIN_Cozinha = 19; //mudar o pino depois 
int cachePresenca = 0;
byte ldrValue = 0;

DHT dhtCozinha(DHTPIN_Cozinha, DHTTYPE);
DHT dhtQuarto(DHTPIN_Quarto, DHTTYPE);
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

void setup(){
    Serial.begin(115200);
    // Serial1.begin(9600, SERIAL_8N1, RXD2, TXD2);
    Serial2.begin(9600, SERIAL_8N1, RXD1, TXD1); 
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }

    Serial.println("Initializing app...");
    ssl_client.setInsecure();
    initializeApp(aClient, app, getAuth(user_auth), asyncCB, "authTask");
    app.getApp<RealtimeDatabase>(Database);
    Database.url(DATABASE_URL);

    pinMode(ledSala, OUTPUT); 
    // pinMode(ledCozinha, OUTPUT); 
    pinMode(ledQuarto, OUTPUT); 
    pinMode(ledBanheiro, OUTPUT);
    pinMode(pinoPIR, INPUT); 
    pinMode(LDR_PIN_Quarto, INPUT);
    pinMode(LDR_PIN_Sala, INPUT);
    pinMode(LDR_PIN_Banheiro, INPUT);
    pinMode(LDR_PIN_Cozinha, INPUT);
    dhtCozinha.begin();
    dhtQuarto.begin();
    pinMode(redLedRGB, OUTPUT);
    pinMode(greenLedRGB, OUTPUT);
    pinMode(blueLedRGB, OUTPUT);
    pinMode(motorQuartoA1, OUTPUT);
    pinMode(motorQuartoB1, OUTPUT);
    pinMode(pinEn1, OUTPUT);
}

void loop(){
    app.loop();
    Database.loop();
    if (app.ready()){  
      getDados();
    }
}

void asyncCB(AsyncResult &aResult)
{

    if (aResult.isEvent())
    {
       Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());
    }

    if (aResult.isDebug())
    {
        Firebase.printf("Debug task: %s, msg: %s\n", aResult.uid().c_str(), aResult.debug().c_str());
    }

    if (aResult.isError())
    {
        Firebase.printf("Error task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.error().message().c_str(), aResult.error().code());
    }

    if (aResult.available())
    {
        Firebase.printf("task: %s, payload: %s\n", aResult.uid().c_str(), aResult.c_str());
    }
}

void getDados(){
  String jsonData = Database.get<String>(aClient, "/smart_home/json");
  if (aClient.lastError().code() == 0) {
    DynamicJsonDocument doc(2048);
    Serial.println("chegou json");
    DeserializationError error = deserializeJson(doc, jsonData);
    if (error) {
    }
    getEstates(jsonData, doc);
  }
}

void getEstates(String jsonData, DynamicJsonDocument doc){
  JsonObject comodos = doc["comodos"];
  for (JsonPair comodo : comodos) {
    const char* nomeComodo = comodo.key().c_str(); 
    JsonObject sensores = comodo.value()["sensores"];
    for (JsonPair sensor : sensores) {
      const char* tipoSensor = sensor.key().c_str(); 
      JsonObject sensorData = sensor.value().as<JsonObject>();
      swhitchComfortable(nomeComodo, sensorData["valor"], sensorData["id"], tipoSensor, sensorData);
    }
  }
}

void swhitchComfortable(const char* nomeComodo, int ultimoValor, int id, const char* tipoSensor, JsonObject sensorData){
  Comodo comodo = getComodoEnum(nomeComodo);
  Sensor sensor = getSensoresEnum(tipoSensor);
  if(sensor == 8){
    analogWrite(redLedRGB, sensorData["r"]);
    analogWrite(greenLedRGB, sensorData["g"]);
    analogWrite(blueLedRGB, sensorData["b"]);
  }
  switch(comodo){
    case 3: updateBanheiro(ultimoValor, sensor, id, tipoSensor, nomeComodo);
      break;
    case 2: updateCozinha(ultimoValor, sensor, id, tipoSensor, nomeComodo);
      break;
    case 1: updateQuarto(ultimoValor, sensor, id, tipoSensor, nomeComodo);
      break;
    case 0: updateSala(ultimoValor, sensor, id, tipoSensor, nomeComodo);
      break;
  }
}

void updateBanheiro(int valor, Sensor sensor,int id, const char* tipoSensor, const char* nomeComodo){
   switch(sensor){ 
    case 4: digitalWrite(ledBanheiro, valor);
      break;
    case 2: pushData(tipoSensor, id, map(analogRead(LDR_PIN_Banheiro), 0, 4095, 0, 255) , nomeComodo);
      break;
  }
}

void updateCozinha(int valor, Sensor sensor, int id, const char* tipoSensor, const char* nomeComodo){
   switch(sensor){
    case 4: digitalWrite(ledCozinha, valor);
      break;
    case 3: pushData(tipoSensor, id, dhtCozinha.readTemperature() , nomeComodo);
      break;
    case 2: ldrValue = map(analogRead(LDR_PIN_Cozinha), 0, 4095, 0, 255);
            pushData(tipoSensor, id, ldrValue , nomeComodo);
      break;
    case 1: pushData(tipoSensor, id, dhtCozinha.readHumidity() , nomeComodo);
      break;
  }
}

void updateQuarto(int valor, Sensor sensor, int id, const char* tipoSensor, const char* nomeComodo){
    String ausente = Database.get<String>(aClient, "/smart_home/json/ausente");
   switch(sensor){
    // case 9:
    //   if (Serial1.available()) {
    //     Serial1.print(valor); // colocar serial.write se der errado
    //     Serial.print("servo: ");
    //     Serial.println(valor);
    //  }  
    //   break;
    case 8:
      break;
    break;
    case 7: 
      break;
    case 6:
      analogWrite(pinEn1, valor);
      digitalWrite(motorQuartoA1, HIGH);
      digitalWrite(motorQuartoB1, LOW);
      break;
    case 5: 
      // if (Serial2.available()) {
      //   Serial2.print(valor); // colocar serial.write se der errado
      //   Serial.println("Escrevi no lcd");
      // }
      // Serial.print("lcd: ");
      // Serial.println(valor);
      break;
    case 4: 
            digitalWrite(ledQuarto, valor);
      break;
    case 3: pushData(tipoSensor, id, dhtQuarto.readTemperature() , nomeComodo);
            Serial.println(dhtQuarto.readTemperature());
      break;
    case 2: ldrValue = map(analogRead(LDR_PIN_Quarto), 0, 4095, 0, 255);
            pushData(tipoSensor, id, ldrValue , nomeComodo);
      break;
    case 1: pushData(tipoSensor, id, dhtQuarto.readHumidity() , nomeComodo);
            Serial.println(dhtQuarto.readHumidity());
      break;
    case 0:
      if(ausente == "1" && Serial2.available()){
        Serial2.print(valor); // coloca serial.write se der errado
        Serial.print("pir: ");
        Serial.println(valor);
      }
      break;
  }
}

void updateSala(int valor, Sensor sensor, int id, const char* tipoSensor, const char* nomeComodo){
   switch(sensor){
    case 4: digitalWrite(ledSala, valor);
      break;
    case 2: ldrValue = map(analogRead(LDR_PIN_Sala), 0, 4095, 0, 255);
            pushData(tipoSensor, id, ldrValue , nomeComodo);
            Serial.println(ldrValue);
      break;
    case 0: pushData(tipoSensor, id, digitalRead(pinoPIR), nomeComodo);
      break;
  }
}

void pushData(const char* tipoSensor, int id, int valor, const char* nomeComodo){
  String caminho = String("/smart_home/json/comodos/") + nomeComodo + "/sensores/" + tipoSensor + "/valor";
  Database.set<int>(aClient,caminho, valor);
}

Comodo getComodoEnum(const char* nomeComodo) {
    if (strcmp(nomeComodo, "sala") == 0) return SALA;
    if (strcmp(nomeComodo, "quarto") == 0) return QUARTO;
    if (strcmp(nomeComodo, "cozinha") == 0) return COZINHA;
    if(strcmp(nomeComodo, "banheiro") == 0) return BANHEIRO;
}

Sensor getSensoresEnum(const char* sensor){
  if(strcmp(sensor, "umidade") == 0) return UMIDADE;
  if(strcmp(sensor, "presenca") ==  0) return PRESENCA;
  if(strcmp(sensor, "distancia") == 0) return DISTANCIA;
  if(strcmp(sensor, "led") == 0) return LED;
  if(strcmp(sensor, "motor") == 0) return MOTOR;
  if(strcmp(sensor, "lcd") == 0) return LCD;
  if(strcmp(sensor, "luz") == 0) return LUZ;
  if(strcmp(sensor, "temperatura") == 0) return TEMPERATURA;
  if(strcmp(sensor, "led_rgb") == 0) return LED_RGB;
}



