#!/usr/bin/env bash

# Download and install OpenJDK 15.0.2
curl -L "https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.tar.gz" -o java.tar.gz

tar xzf java.tar.gz --strip-components=1
rm java.tar.gz

# Download and install org.json library
mkdir -p lib/json
curl -L "https://repo1.maven.org/maven2/org/json/json/20240303/json-20240303.jar" -o lib/json/json.jar