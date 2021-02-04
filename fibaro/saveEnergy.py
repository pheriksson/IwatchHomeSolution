import requests, json


#handler for fibaro object -> flag to lookUpBinarySwitch and turn on/off.

def main():
    # ---------------------------- Main -----------------------------
    fibaro_IP = "130.240.114.44"
    fibaro_User = "unicorn@ltu.se"
    fibaro_Password = "jSCN47bC"

    requests_base= "http://%s:%s@%s" %(fibaro_User, fibaro_Password, fibaro_IP)
    lookUpBinarySwitch(requests_base)



def lookUpBinarySwitch(requests_base):
    request = '%s/api/devices/' %(requests_base)
    r = requests.get(request)
    r_dict = r.json()
    #Slow to select all devices?? maybe change get request for nodes of a specific type.
    activeNodes = []
    if r.ok:
        for node in r_dict:
            if node['type'] == 'com.fibaro.binarySwitch' && node['properties']['energy'] > 0:
                print(f"node: {node['id']}, name: {node['name']} is currently consuming W: {node['properties']['energy']}");
                activeNodes.append(node['id'])
    else:
        print(f"Something went wrong")
    return activeNodes


# Turn on all binarySwitches previously closed.
def turnOnClosed(requestBase,binarySwitches):
    payload = {'deviceID':None,'name':'turnOn'}
    request = f'{requests_base}/api/callAction'
    for node in binarySwitches:
        payload['deviceID'] = int(node)
        r = request.get(request, params=payload)
        if r.status_code == 200:
            print(f'node: {int(node)} succesfully turned on!')
        ## Change r to post, doing this to just confirm that the process works.


# Turn off all consuming binarySwitches. Return list off all switches turned off.
def turnOffConsuming(requestBase, binarySwitches):
    payload = {'deviceID':None,'name':'turnOff'}
    request = f'{requests_base}/api/callAction'
    nodesOff = []
    for node in binarySwitches:
        payload['deviceID'] = int(node)
        r = request.get(request, params=payload)
        if r.status_code == 200:
            nodesOff.append(node)
            #As with turn on closed, try and change to post instead of a get req.
    return nodesOff











if __name__ == "__main__":
    main()
