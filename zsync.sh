#!/usr/bin/env bash

#rsync -avu "/media/sf_laGGer-dev/" "/home/lagger/src" 
rsync -avu --exclude "Python-3.6.9" --exclude "libwebsockets" \
 --exclude  "libnice" --exclude "janus-gateway" \
 --exclude "paho.mqtt.c" --exclude "rabbitmq-c"  \
 "/media/sf_laGGer-dev"  "/home/lagger/src/" 
