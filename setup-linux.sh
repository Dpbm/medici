#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install libsqlite3-0 libsqlite3-dev openjdk-19-jdk
sudo update-alternatives --config java

echo "Now remember to setup JAVA_HOME JDK_HOME and STUDIO_JDK to ensure the correct JDK version during build"
echo "check: "
echo "https://www.baeldung.com/java-home-on-windows-mac-os-x-linux"
echo "https://developer.android.com/tools/variables"
