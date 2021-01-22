
import paho.mqtt.client as MQTT
import time
import json

def print_json(msg):
    json_object = json.loads(msg);
    #print(json_object["message"]) #type str
    #print(json_object["time"]+"\n")
    #json_formated_string = json.dumps(json_object, indent = 2);
    #print(json_formated_string);
    #print(json_object["time"]+" : "+json_object["message"]);
    if(json_object["message"][0:6] == "REPORT"):
        #arr = json_object["message"].split(",");
        print(json_object["time"]+" : "+json_object["message"]);

    #report_location(json_object["message"], json_object["time"]);

def report_location(msg,time):
    if (msg[0:6] == "REPORT"):
        arr = msg.split(",");
        print(msg);
        print("x:{} y:{} z:{} ".format(arr[2],arr[3],arr[4]));



def on_connect(client, msg, flags, rc):
    global loop_flag
    if rc==0:
        print("Connect succesfull to broker: ",rc)
    else:
        print("Connect error: ", rc)
    loop_flag = 0;

def on_message(client, userdata, message):
    print_json(str(message.payload.decode("utf-8"))); ##Why we need to decode: https://stackoverflow.com/questions/53334451/python-3-paho-mqtt-published-subscribed-json-message-wont-parse


broker_adr='xxxxxx'; #fyll i vid koppling.
broker_port=1883;
client = MQTT.Client();
client.on_connect = on_connect;
client.on_message = on_message;
client.connect(broker_adr,broker_port);
client.loop_start();




loop_flag=1;
counter=0;
while loop_flag==1:
    print("Awaiting connect callback...");
    time.sleep(0.4);
    counter+=1;

print("Subscribing to everything...");
client.subscribe("#"); #qos 0, for testing
counter = 0;
while counter < 200:
    #loopar i 20 sec bara så att jag inte behöver avbryta och inte disconnecta så de inte blir ngn
    #half open socket och de skiter sig.
    time.sleep(0.2);
    counter+=1;


client.disconnect();
client.loop_stop();

print("eyy");
