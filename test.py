
from fibaro import doorWindowSensors as FB
from widefind import connect_MQTT as WF
#import widefind/connect_MQTT.WFMQTT as WF



def main():
    t1 = WF.WFMQTT('130.240.74.55',1883);
    while True:
        t2 = FB.main();
        #ex, test will return open doors.
        if (len(test)>0):
            for open in test:
                print("door {} is open".format(open));
            print("Synchronous call for widefind initiating");
            t1.start();


main();
