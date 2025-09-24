#!/usr/bin/env bash

# Download and install Node.js 22.9.0
curl -L "https://nodejs.org/dist/v22.9.0/node-v22.9.0-linux-x64.tar.xz" -o node.tar.xz

tar xf node.tar.xz --strip-components=1
rm node.tar.xz