# Heartrate-from-scosche-to-unity
The project's goal is to get to measure the heart rate using the Scosche rhythm+ armband and get the results in real time in Unity.

# Introduction
At first I thought that getting the heartrate from the armband to Unity would be a piece of cake (relatively). Connect it to my PC and somehow get the values read by the armband into unity with a small script. Maybe in the worst case create a small script to connect to the armband directly from unity.

The method I ended up using is way more dirty and requires many many steps so hold on tight!

# Outline
First thing, the armband doesn't connect to computers, the only support I found was mobile. So I installed the mobile app on my iPhone and lucky for me, it works with Healthkit. So the heartrate goes to Healthkit, I created a small app to pick that data up in realtime. It then connects to a socket server on my computer. A small unity scrip then connects to the socket server on the computer and the server send the data straight to unity.

Armband -> [rythm sync](https://itunes.apple.com/us/app/rhythm-sync/id1226606963?mt=8) -> Home made iOS app -> node.js socket server -> Unity C# script

In this is repo I'll include the iOS app I built, the node.js server and the unity script.

# iOS App
The iOS app creates a hook that will update the current heartrate everytime the scosche app (rythm sync) updates the heartrate in healthkit. You must setup Rythm Sync to sync with the Health app. Once that is done, make sure the iOS app has the permissions to read Health data. Press "Get Current HR" to get the lastest Heartrate. 


- "Get Current HR" will get the lastest HR (Heartrate) one time.
- "Auto Update Display" will setup the hook to automatically update the HR.
- "connect" will make the app attempt to connect to the given address.

The iOS app uses Socket-io-swift

# Socket server
Just run the server. On the ios app, enter ip address and port of the machine running the server and press connect. The correct format is ip:port (e.g. 192.168.1.1:3000). The server should respond to the HR data and start emiting data to all connected clients. We will use this in the last step.

# Unity script
You will first need to import the [socket-io](https://assetstore.unity.com/packages/tools/network/socket-io-for-unity-21721) asset to your unity scene.
Create an empty object and attach the "script path goes here" to it.
Then attached the seccond script "Heartrate-from-scosche-to-unity/Unity Scripts/HeartBeat.cs" (included in this repo) to the object.
If everything is done properly, the object should have a public variable that automatically updates with the most recent heartrate data.
