import requests, json
import time

#TODO: Find a way to turn off node instead of using the GET api/callAction method. -> post api/device/deviceID=x&param=0 or something.

#for fibaro object -> flag to lookUpBinarySwitch and turn on/off.

def main():
    # ---------------------------- Main -----------------------------
    fibaro_IP = "130.240.114.44"
    fibaro_User = "unicorn@ltu.se"
    fibaro_Password = "jSCN47bC"

    requests_base= "http://%s:%s@%s" %(fibaro_User, fibaro_Password, fibaro_IP)

    selectArr = lookUpBinarySwitch(requests_base);
    print(selectArr)
    turnedOffArr = turnOffConsuming(requests_base,selectArr);
    #turnedOffArr = turnOffConsuming(requests_base,[30]) #Used for bug testing.
    print(turnedOffArr)

    time.sleep(3)
    failedArr = turnOnClosed(requests_base, turnedOffArr)
    if(len(failedArr)== 0):
        print(f'all devices succesfully turned on!')
    else:
        print(f'nodes failed to turn back on :{failedArr}')

def lookUpBinarySwitch(requests_base):
    request = '%s/api/devices/' %(requests_base)
    r = requests.get(request)
    r_dict = r.json()
    activeNodes = []
    if r.ok:
        for node in r_dict:
            try:
                ##roomID 220 = U121.
                if (node['roomID']==220) and (node['type'] == 'com.fibaro.binarySwitch') and (node['properties']['power'] > 10):
                    print(f"node: {node['id']}, name: {node['name']} is currently consuming ({node['properties']['power']})W");
                    activeNodes.append(node['id'])
            except KeyError:
                print('no such key');
    else:
        print('Something went wrong')
    return activeNodes

# Turn off all consuming binary switches. Return list off all switches turned off.
def turnOffConsuming(requestBase, binarySwitches):
    payload = {'deviceID':None,'name':'turnOff'}
    request = f'{requestBase}/api/callAction/'
    #request = '%s/api/callAction/' %(requestBase)
    nodesOff = []
    for node in binarySwitches:
        payload['deviceID'] = int(node)
        r = requests.get(request, params=payload)
        if r.status_code == 200:
            nodesOff.append(node)
            print(f'node: ({node}) turned off!')
        elif r.status_code == 202:
            nodesOff.append(node)
            print(f'node: ({node}) request sent, but not confirmed processing')
        else:
            print(f'something went wrong, {r.status_code}');
            #As with turn on closed, try and change to post instead of a get req.
    return nodesOff





# Turn on all binary switches previously closed. Return list of nodes which failed to turn on.
def turnOnClosed(requestBase,binarySwitches):
    payload = {'deviceID':None,'name':'turnOn'}
    request = f'{requestBase}/api/callAction/'
    nodesError = []
    for node in binarySwitches:
        payload['deviceID'] = node
        r = requests.get(request, params=payload)
        print(f'turnOnClosed status code: {r.status_code}')
        if r.status_code == 200:
            print(f'node: ({node}) turned on!')
        else:
            print(f'node: {node} failed with status: {r.status_code}')
            nodesError.append(node) #add some log??maybe for the future, external server.
    return nodesError








if __name__ == "__main__":
    main()
