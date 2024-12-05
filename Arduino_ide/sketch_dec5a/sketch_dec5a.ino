#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>

#define WIFI_SSID "A 10"
#define WIFI_PASSWORD "12345678"
#define API_KEY "AIzaSyAM7rxPXK3n8g69MNEXZzsLKOXn9cwARWk"
#define USER_EMAIL "adm@gmail.com"
#define USER_PASSWORD "admin123"
#define DATABASE_URL "https://smart-home-2e603-default-rtdb.firebaseio.com/"

FirebaseApp app;
DefaultNetwork network;
WiFiClientSecure ssl_client;
using AsyncClient = AsyncClientClass;
RealtimeDatabase Database;

void asyncCB(AsyncResult &aResult);
UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD, 3000);
AsyncClient aClient(ssl_client, getNetwork(network));

unsigned long tmo = 0;

void setup(){

    Serial.begin(115200);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    unsigned long ms = millis();
    while (WiFi.status() != WL_CONNECTED)
    {
       // Serial.print(".");
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
   // Database.url(DATABASE_URL);
}

void loop(){

    app.loop();
    Database.loop();

    if (app.ready() && millis() - tmo > 3000)
    {
      
       tmo = millis();
       
       // User code can be put here
       Database.get(aClient, "/test/int", asyncCB, "someTask");
       //Serial.println("oi");
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
