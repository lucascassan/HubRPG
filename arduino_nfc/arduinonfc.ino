#include <Arduino.h> 
#include <SPI.h>
#include <MFRC522.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>

//RFID
#define SS_PIN 4  //D2
#define RST_PIN 5 //D1

//Wireless Config
const char *SSID = "Cassan";
const char *PSWD = "Di02071997";

//Socket Config
const uint16_t port = 1234;
const char *host = "192.168.15.150";
const char *idDevice = "1";

//Variaveis
WiFiClient client;
MFRC522 mfrc522(SS_PIN, RST_PIN);   

//prototypes 
void sendSocketMessage(const String &value);

void setup() 
{
  Serial.begin(9600);     // Inicializa Comunicação Serial para Debug 
  SPI.begin();            // Inicializa SPI bus
  mfrc522.PCD_Init();     // Inicializa MFRC522
  WiFi.mode(WIFI_STA);    // Inicializa Wi-fi
  WiFi.begin(SSID,PSWD);  // Conecta-se ao Wi-Fi
}

void loop() 
{
  //Leitura da Tag 
  if ( ! mfrc522.PICC_IsNewCardPresent())
    return;
  if ( ! mfrc522.PICC_ReadCardSerial()) 
    return;

  //Tratamento dos Dados
  String content;
  for (int i = 0; i < mfrc522.uid.size; i++) 
  {
    content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? "0":""));
    content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }

  //Debug
  Serial.println("Leitura: " +content);

  //Envia ID do Card para o Socket Server
  sendSocketMessage(content); 
  delay(3000);
}

void sendSocketMessage(const String &value){
    //Conexão
    if (!client.connect(host, port)){
      Serial.println("Socket: Erro ao conectar");
      return;
    }

    //Tratamento de Dados
    String message = "nfc";
    message = message+";"+idDevice; 
    message = message+";"+value;

    //Envio
    client.println(message);
    Serial.println("Enviando: " + message);
    delay(250);

    //Debug de Retorno
    Serial.print("Retorno: "); 
    while (client.available() > 0)
    {
        char c = client.read();
        Serial.write("success");
    }
    client.stop();
}
