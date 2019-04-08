# Heartrate-from-scosche-to-unity
The project's goal is to get to measure the heart rate using the Scosche rhythm+ armband and get the results in real time in Unity.

# Introduction

At first I thought that getting the heartrate from the armband to Unity would be a piece of cake (relatively). Connect it to my PC and somehow get the values read by the armband into unity with a small script. Maybe in the worst case create a small script to connect to the armband directly from unity.

The method I ended up using is way more dirty and requires many many steps so hold on tight!

# Outline
First thing, the armband doesn't connect to computers, the only support I found was mobile. So I installed the mobile app on my iPhone and lucky for me, it works with Healthkit. So the heartrate goes to Healthkit, I created a small app to pick that data up in realtime. It then connects to a socket server on my computer. A small unity scrip then connects to the socket server on the computer and the server send the data straight to unity.

Armband -> [rythm sync](https://itunes.apple.com/us/app/rhythm-sync/id1226606963?mt=8) -> Home made iOS app -> node.js socket server -> Unity C# script

In this is repo I'll include the iOS app I built, the node.js server and the unity script.
