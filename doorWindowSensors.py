import requests, json
def main():
    # ---------------------------- Main -----------------------------
    fibaro_IP = "130.240.114.44"
    fibaro_User = "unicorn@ltu.se"
    fibaro_Password = "jSCN47bC"

    requests_base= "http://%s:%s@%s" %(fibaro_User, fibaro_Password, fibaro_IP)

    lookUpDoorWindowSensors(requests_base)


# ----- Request all devices and looks up doorWindowSensors------------
def lookUpDoorWindowSensors(requests_base):

    request = '%s/api/devices/' %(requests_base)
    
    r = requests.get(request)
    r_dict = r.json()
    if r.ok:
        for node in r_dict:
            if node['baseType'] == 'com.fibaro.doorWindowSensor':
                if node['properties']['value']:
                    print("ID: %s öppen" %(node["id"]))
                else:
                    print("ID: %s stängd" %(node['id']))
    else:
        print("Something went wrong!")
# --------------------------- Run ------------------------------------
if __name__ == "__main__":
    main()