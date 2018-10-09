//www.elegoo.com
//2016.06.13
#include <SimpleDHT.h>
#include <FirebaseArduino.h> 
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#define FIREBASE_HOST "dsdroomate.firebaseio.com"                        
#define FIREBASE_AUTH "7HnxD6NdTqyzXOqn0NJZKot58X83uI0wyqlpqj3K"              
#define DIRA 3
#define DIRB 4

//secret database 7HnxD6NdTqyzXOqn0NJZKot58X83uI0wyqlpqj3K
//url https://dsdroomate.firebaseio.com/
// Replace with your network credentials
const char* ssid = "FiberBox-DCF";
const char* password = "ouverture";     
// for DHT11, 
//      VCC: 5V or 3V
//      GND: GND
//      DATA: 2
int pinDHT11 = 2;
SimpleDHT11 dht11;
bool ledState = LOW;
String output5State = "off";
String output4State = "off";
const int output5 = 5;
const int output4 = 4;
void setup() {
  
  Serial.begin(115200);
  // Initialize the output variables as outputs
  pinMode(output5, OUTPUT);
  pinMode(output4, OUTPUT);
  // Set outputs to LOW
  digitalWrite(output5, LOW);
  digitalWrite(output4, LOW);
WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) 
  {
    delay(1000);
    Serial.println("Connecting...");
  }
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH);
  
}

void loop() {
    if (WiFi.status() == WL_CONNECTED) 
  {
  
  // start working...
  Serial.println("=================================");
  Serial.println("Sample DHT11...");
  
  // read with raw sample data.
  byte temperature = 0;
  byte humidity = 0;
  byte data[40] = {0};
  if (dht11.read(pinDHT11, &temperature, &humidity, data)) {
    Serial.print("Read DHT11 failed");
    return;
  }
  
  Serial.print("Sample RAW Bits: ");
  for (int i = 0; i < 40; i++) {
    Serial.print((int)data[i]);
    if (i > 0 && ((i + 1) % 4) == 0) {
      Serial.print(' ');
    }
  }
/*
float h = humidity;
      // Read temperature as Celsius
      float t = temperature;
    
   StaticJsonBuffer<200> jsonBuffer;
        JsonObject& root = jsonBuffer.createObject();
        root["temperature"] = t;
        root["humidity"] = h;
Firebase.setFloat("temperature", temperature);
//Serial.print("helo",name);

if (Firebase.failed()) {
            Serial.print("Firebase Pushing /sensor/dht failed:");
            Serial.println(Firebase.error()); 
}
else{
            Serial.print("Firebase Pushed /sensor/dht ");
//            Serial.println(name);
}
   if       (temperature == 24 )  
   {
  output5State = "on";
              digitalWrite(output5, HIGH); 
               output4State = "off";
               
              digitalWrite(output4, LOW);


   

}
else if (temperature > 24 )  {
     output5State = "off";
              digitalWrite(output5, LOW);
     output4State = "on";
              digitalWrite(output4, HIGH);
    }
    */
StaticJsonBuffer<200> jsonBuffer;
        JsonObject& root = jsonBuffer.createObject();
        root["temperature"] = temperature;
        root["humidity"] = humidity;
    
          Firebase.push("/sensor/dsd1", root);
          
   if       (temperature == 24 )  
   {
  //output5State = "on";
              //digitalWrite(output5, HIGH); 
              digitalWrite(DIRA,HIGH);
               output4State = "off";
               
              digitalWrite(output4, LOW);


   

}
else if (temperature > 24 )  {
     output5State = "off";
              digitalWrite(output5, LOW);
     output4State = "on";
              digitalWrite(output4, HIGH);
    }
  Serial.println("");
  Serial.print("Sample OK: ");
  Serial.print(temperature); Serial.print(" *C, ");
  Serial.print((int)humidity); Serial.println(" %");
  
  // DHT11 sampling rate is 1HZ.
  delay(60000);
  }
  }
