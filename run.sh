#!/bin/sh

docker build -t vmware-python . && docker run -p 9191:8080 vmware-python