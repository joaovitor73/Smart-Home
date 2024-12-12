#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include <DHT.h>

#define WIFI_SSID "A"
#define WIFI_PASSWORD "12345678"
#define API_KEY "AIzaSyB2hyLRaBR3ZVqmnHYkvXN1IvZV_NJusFc"
#define USER_EMAIL "adm@gmail.com"
#define USER_PASSWORD "admin123"
#define DATABASE_URL "https://smart-home-876c0-default-rtdb.firebaseio.com/"
#define DHTTYPE DHT22
#define FIREBASE_PROJECT_ID "smart-home-876c0"
#define FIREBASE_CLIENT_EMAIL "bbitprocessoseletivo@gmail.com"

FirebaseApp app;
DefaultNetwork network;
WiFiClientSecure ssl_client;
using AsyncClient = AsyncClientClass;
RealtimeDatabase Database;
Messaging messaging;

void asyncCB(AsyncResult &aResult);
void timeStatusCB(uint32_t &ts);
UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD, 3000);
AsyncClient aClient(ssl_client, getNetwork(network));
const char PRIVATE_KEY[] PROGMEM = "BKkIO1r9WjWnrezP3b2bHFBqcPcQmrtttRfBi97HjDttEiknRifWYfL75p8ksjs9A3LwOeNiJm8f08JUiWfMNGg";
ServiceAuth sa_auth(timeStatusCB, FIREBASE_CLIENT_EMAIL, FIREBASE_PROJECT_ID, PRIVATE_KEY, 3000 /* expire period in seconds (<= 3600) */);

unsigned long tmo = 0; 

const byte ledSala = 2;
const byte ledCozinha = 18;
const byte ledQuarto = 19;
const byte ledBanheiro = 21;
const byte DHTPIN = 5;


const int pinoPIR = 15;
const int LDR_PIN = 34; 
int cachePresenca = 0;
byte ldrValue = 0;

DHT dht(DHTPIN, DHTTYPE);
enum Comodo {
    SALA,
    QUARTO,
    COZINHA,
    BANHEIRO, 
    DESCONHECIDO
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

int cont = 0;
void setup(){

    Serial.begin(115200);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    unsigned long ms = millis();
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Firebase.printf("Firebase Client v%s\n", FIREBASE_CLIENT_VERSION);

    Serial.println("Initializing app...");
    ssl_client.setInsecure();
    initializeApp(aClient, app, getAuth(user_auth), asyncCB, "authTask");
    app.getApp<RealtimeDatabase>(Database);
    app.getApp<Messaging>(messaging);
    Database.url(DATABASE_URL);

    pinMode(ledSala, OUTPUT); 
    pinMode(ledCozinha, OUTPUT); 
    pinMode(ledQuarto, OUTPUT); 
    pinMode(ledBanheiro, OUTPUT);
    pinMode(pinoPIR, INPUT); 
    pinMode(LDR_PIN, INPUT);
    dht.begin();
}

void loop(){

    app.loop();
    Database.loop();

    if (app.ready()){  
    
       //configureJson();
      getDados();
      // Database.get(aClient, "/smart_home/json", asyncCB);
     //lerLdr();
    }
}
void asyncCB(AsyncResult &aResult)
{

    if (aResult.isEvent())
    {
       Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());
      // getDados();
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
    //Serial.println("ok");
    //Serial.println("Retrieved JSON:");
    //Serial.println(jsonData);

    DynamicJsonDocument doc(2048);
    DeserializationError error = deserializeJson(doc, jsonData);
    if (error) {
        Serial.print("deserializeJson() failed: ");
        Serial.println(error.c_str());
        return;
    }
    getEstates(jsonData, doc);
  }else{
    Serial.print("Failed to get JSON: ");
    Serial.println(aClient.lastError().message());
  }
}

void getEstates(String jsonData, DynamicJsonDocument doc){
  JsonObject comodos = doc["comodos"];
  for (JsonPair comodo : comodos) {
    const char* nomeComodo = comodo.key().c_str(); 
    JsonObject sensores = comodo.value()["sensores"];

    Serial.printf("Cômodo: %s\n", nomeComodo);
    for (JsonPair sensor : sensores) {
      const char* tipoSensor = sensor.key().c_str(); 
      JsonObject sensorData = sensor.value().as<JsonObject>();
      swhitchComfortable(nomeComodo, sensorData["valor"], sensorData["id"], tipoSensor);
    }
  }
}

void swhitchComfortable(const char* nomeComodo, int ultimoValor, int id, const char* tipoSensor){
  Comodo comodo = getComodoEnum(nomeComodo);
  Sensor sensor = getSensoresEnum(tipoSensor);
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
    case 2: pushData(tipoSensor, id, map(analogRead(LDR_PIN), 0, 4095, 0, 255) , nomeComodo);
      break;
  }
}

void updateCozinha(int valor, Sensor sensor, int id, const char* tipoSensor, const char* nomeComodo){
   switch(sensor){
    case 4: digitalWrite(ledCozinha, valor);
      break;
    case 3: pushData(tipoSensor, id, dht.readTemperature() , nomeComodo);
      break;
    case 2: ldrValue = map(analogRead(LDR_PIN), 0, 4095, 0, 255);
            pushData(tipoSensor, id, ldrValue , nomeComodo);
      break;
    case 1: pushData(tipoSensor, id, dht.readHumidity() , nomeComodo);
      break;
  }
}

void updateQuarto(int valor, Sensor sensor, int id, const char* tipoSensor, const char* nomeComodo){
   switch(sensor){
    case 8: 
      break;
    case 7: 
      break;
    case 6: 
      break;
    case 5:
      break;
    case 4: digitalWrite(ledQuarto, valor);
      break;
    case 3: pushData(tipoSensor, id, dht.readTemperature() , nomeComodo);
      break;
    case 2: ldrValue = map(analogRead(LDR_PIN), 0, 4095, 0, 255);
            pushData(tipoSensor, id, ldrValue , nomeComodo);
      break;
    case 1: pushData(tipoSensor, id, dht.readHumidity() , nomeComodo);
      break;
  }
}

void updateSala(int valor, Sensor sensor, int id, const char* tipoSensor, const char* nomeComodo){
   switch(sensor){
    case 4: digitalWrite(ledSala, valor);
      break;
    case 2: ldrValue = map(analogRead(LDR_PIN), 0, 4095, 0, 255);
            pushData(tipoSensor, id, ldrValue , nomeComodo);
      break;
    case 0: pushData(tipoSensor, id, digitalRead(pinoPIR), nomeComodo);
      break;
  }
}


void pushData(const char* tipoSensor, int id, int valor, const char* nomeComodo){
  String caminho = String("/smart_home/json/comodos/") + nomeComodo + "/sensores/" + tipoSensor + "/valor";
  if (Database.set<int>(aClient,caminho, valor)) {
    Serial.println("Dados de " + String(tipoSensor) + " enviados com sucesso!");
  } 
}

Comodo getComodoEnum(const char* nomeComodo) {
    if (strcmp(nomeComodo, "sala") == 0) return SALA;
    if (strcmp(nomeComodo, "quarto") == 0) return QUARTO;
    if (strcmp(nomeComodo, "cozinha") == 0) return COZINHA;
    if(strcmp(nomeComodo, "banheiro") == 0) return BANHEIRO;
    return DESCONHECIDO;
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
  if(strcmp(sensor, "led_rgb")) return LED_RGB;
}

void configureJson() {
  String json = R"({
  "comodos": {
    "sala": {
      "sensores": {
        "presenca": {"id": 1, "valor": 1},
        "luz": {"id": 2, "valor": 80},
        "led": {"id": 3, "valor": 0}
      }
    },
    "banheiro": {
      "sensores": {
        "luz": {"id": 4, "valor": 60},
        "led": {"id": 5, "valor": 0}
      }
    },
    "cozinha": {
      "sensores": {
        "umidade": {"id": 6, "valor": 50},
        "luz": {"id": 7, "valor": 90},
        "temperatura": {"id": 8, "valor": 30},
        "led": {"id": 9, "valor": 0}
      }
    },
    "quarto": {
      "sensores": {
        "umidade": {"id": 10, "valor": 40},
        "luz": {"id": 11, "valor": 75},
        "temperatura": {"id": 12, "valor": 30},
        "led": {"id": 13, "valor": 0},
        "lcd": {"id": 14, "valor": 1, "msg": 0},
        "motor": {"id": 15, "valor": 0},
        "led_rgb": {"id": 16, "r": 0, "g": 0, "b": 0}
      }
    }
  }
}
)";

  bool status = Database.set<object_t>(aClient, "/smart_home/json", object_t(json));
  if (status)
    Serial.println("JSON salvo com sucesso!");
  else
    Serial.println("Erro ao salvar JSON.");
}



