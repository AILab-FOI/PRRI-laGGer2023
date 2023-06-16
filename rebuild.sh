#!/usr/bin/env bash

cd ..

cp -R lagger/* src

cd src

chown -R lagger *

#rm -rf libnice
#rm -rf libwebsockets
#rm -rf cd paho.mqtt.c
#rm -rf rabbitmq-c

#sh install.sh
