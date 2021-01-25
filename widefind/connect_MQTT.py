
import paho.mqtt.client as MQTT
import time
import json

class WFMQTT:


    def __init__(self, adr, port):
        self.adr = adr
        self.port = port
        self.client = MQTT.Client();
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        self.conn_flag = 0
        self.x = self.y = self.z = 0;

    def report_location(self, msg):
        json_object = json.loads(msg);
        #print(json_object["source"]+" : "+json_object["message"])
        if (json_object["message"][0:6] == "REPORT"):
            arr = msg.split(",");
            #print(json_object["time"]+" : "+json_object["message"]);
            print("x:{} y:{} z:{} ".format(arr[3],arr[4],arr[5]));
            self.x = arr[3]; self.y = arr[4]; self.z = arr[5];


    def on_connect(self,client, msg, flags, rc):
        if rc==0:
            print("Connect succesfull to broker: ",rc)
            self.conn_flag = 1
        else:
            print("Connect error: ", rc)
            self.client.loop_stop() #abort.
            #ABORT connection or RETRY connection

    def on_message(self, client, userdata, message):
        self.report_location(str(message.payload.decode("utf-8")));


    def main(self):
        self.client.connect(self.adr,self.port);
        self.client.loop_start(); #END LOOP IN on_connect if shits fucked
        while(self.conn_flag!=1):
            print("Awaiting connect callback...");
            time.sleep(0.5);
        print("Subscribing to everything...");
        self.client.subscribe("#"); #qos 0, for testing
        print("done subscribing");
        counter = 0;
        while counter < 300:
            time.sleep(0.2);
            counter+=1;
            #loopar i 20 sec bara så att jag inte behöver avbryta och inte disconnecta så de inte blir ngn
            #half open socket och de skiter sig.
        print("disconnecting...");
        self.client.disconnect();
        self.client.loop_stop();
        print("done");

test = WFMQTT('130.240.74.55',1883);
test.main();
#broker_adr='xxxxxx'; #fyll i vid koppling.
#broker_port=1883;
#client = MQTT.Client();
#client.on_connect = on_connect;
#client.on_message = on_message;
#client.connect(broker_adr,broker_port);
#client.loop_start();
