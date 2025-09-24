#!/usr/bin/env bash

# Download and install OpenJDK 21.0.4 from Adoptium
curl -L "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz" -o java.tar.gz

tar xzf java.tar.gz --strip-components=1
rm java.tar.gz

# Download and install org.json library
mkdir -p lib/json
curl -L "https://repo1.maven.org/maven2/org/json/json/20240303/json-20240303.jar" -o lib/json/json.jar