#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <TinyGPSPlus.h>
// WiFi
const char *ssid = "HPC"; // Enter your WiFi name
const char *password = "khongcomang";  // Enter WiFi password

// MQTT Broker
const char *mqtt_broker = "broker.emqx.io";
const char *topic = "esp8266/device";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
const int mqtt_port = 1883;
unsigned long previousMillis = 0;


WiFiClient espClient;
PubSubClient client(espClient);
Adafruit_MPU6050 mpu;
TinyGPSPlus gps;

bool startDevice = true;

void updateLocation(float &longitude, float &latitude) {
  while (Serial.available() > 0) {
    gps.encode(Serial.read());
  }

  if (gps.location.isValid()) {
    Serial.print("Latitude= ");
    Serial.print(gps.location.lat(), 6);
    latitude = gps.location.lat();
    Serial.print(" Longitude= ");
    Serial.println(gps.location.lng(), 6);
    longitude = gps.location.lng();
  } else {
    Serial.println("Waiting for GPS signal...");
  }
}


void callback(char *topic, byte *payload, unsigned int length) {
    Serial.print("Message received on topic: ");
    Serial.println(topic);
    Serial.print("Message:");
    for (unsigned int i = 0; i < length; i++) {
        Serial.print((char) payload[i]);
    }
    Serial.println();
    Serial.println("-----------------------");
}

void setup() {
    // Set software serial baud to 115200;
    Serial.begin(115200);
    // connecting to a WiFi network
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
    }
    Serial.println("Connected to the WiFi network");
    //connecting to a mqtt broker
    client.setServer(mqtt_broker, mqtt_port);
    client.setCallback(callback);
    //connecting to a mqtt broker
    while (!client.connected()) {
        String client_id = "esp8266-client-";
        client_id += String(WiFi.macAddress());
        Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
        if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
            Serial.println("Public emqx mqtt broker connected");
        } else {
            Serial.print("failed with state ");
            Serial.print(client.state());
            delay(2000);
        }
    }
    if (!mpu.begin()) {
        Serial.println("Failed to find MPU6050 chip");
        while (1) {
          delay(10);
        }
    }
    Serial.println("MPU6050 Found!");

    // set accelerometer range to +-8G
    mpu.setAccelerometerRange(MPU6050_RANGE_8_G);

    // set gyro range to +- 500 deg/s
    mpu.setGyroRange(MPU6050_RANGE_500_DEG);

    // set filter bandwidth to 21 Hz
    mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

    delay(100);
}


void loop() {
    client.loop();
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= 5000) {
        previousMillis = currentMillis;
        sensors_event_t a1, g1, temp1;
        mpu.getEvent(&a1, &g1, &temp1);
        Serial.print("Acceleration X: ");
        Serial.print(a1.acceleration.x);
        Serial.print(", Y: ");
        Serial.print(a1.acceleration.y);
        Serial.print(", Z: ");
        Serial.print(a1.acceleration.z);
        Serial.println(" m/s^2");
        float accX1,accY1,accZ1;
        float accX2,accY2,accZ2;
        float accChange;
        float longitude , latitude ;

    /* Print out the values */
        updateLocation(longitude,latitude);

        accX1 = a1.acceleration.x;
        accY1 = a1.acceleration.y;
        accZ1 = a1.acceleration.z;

        delay(5000);
        sensors_event_t a2, g2, temp2;
        mpu.getEvent(&a2, &g2, &temp2);
        Serial.print("Acceleration X2: ");
        Serial.print(a2.acceleration.x);
        Serial.print(", Y2: ");
        Serial.print(a2.acceleration.y);
        Serial.print(", Z2: ");
        Serial.print(a2.acceleration.z);
        Serial.println(" m/s^2");
        accX2 = a2.acceleration.x;
        accY2 = a2.acceleration.y;
        accZ2 = a2.acceleration.z;

        accChange = sqrt(pow((accX1-accX2),2)+pow((accY1-accY2),2)+pow((accZ1-accZ2),2));

        // json serialize
        DynamicJsonDocument data(256);
        data["accchange"] = accChange;
        data["latitude"] = latitude;
        data["longitude"] = longitude;
        data["status"] = startDevice;
        if(!client.connected())
          startDevice = false;
        // publish temperature and humidity
        char json_string[256];
        serializeJson(data, json_string);
        Serial.println(json_string);
        client.publish(topic, json_string, false);
    }
}
