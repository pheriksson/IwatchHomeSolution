# IWatchHomeSolution
IWatchHomeSolution is an application designed to controll the smart home and operates on an apple watch series 6 paired with an iphone 12. The application makes use of Fibaro home center 3, widefinds UWB positioning system and Philips HUE bridge to controll the related sensors within the smart home. Other than controlling the sensors within the home the application also makes use of the built in health monitoring sensors that the apple watch series 6 and iphone 12 provides.

# Build #
Build with Xcode 12.4/ Swift 5.3.2

# Dependencies #
- Third party dependencies
  - [CocoaMQTT](https://github.com/emqx/CocoaMQTT)

# Simulate application with xcode #
1. Clone project.
2. Make sure you have the necessary dependencies configured (should be set up with the project folder).
3. Open up the project with xcode (use the ".xcworkspace" file and NOT the ".xcodeproj" file).
4. Specify addresses and authentication to respective sensor clients used in main file (can be found in /Group8Application/testApp.swift constructor)
5. Select which device to run the project on (Tested on iphone 12 and Smart watch 5 44mm)
6. Run.

(Note, you will only see output from one part of the application at a time, this is because xcode does not allow debugging in different types of devices at the same time)

# Checking connections with sensor clients #
1. Setup connection information to the sensor clients in main file "Group8Application/testApp.swift".
2. Simulate an iOS device.
3. Set the target to "Group8Application/testApp.swift".
4. Run.

The output from the sensor clients will notify of a successful connection or a failed connection from each sensor client.
