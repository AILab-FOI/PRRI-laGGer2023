#!/usr/bin/env bash

#rsync -avu "/media/sf_laGGer-dev/" "/home/lagger/src" 
rsync -avu --delete --exclude "Python-3.6.9" --exclude "libwebsockets" \
 --exclude  "libnice" --exclude "janus-gateway" \
 --exclude "paho.mqtt.c" --exclude "rabbitmq-c"  \
 --exclude "x11docker" --exclude "__pycache__" \
 --exclude ".480x320" --exclude ".5000x5000" \
 --exclude "addr.txt~" --exclude "install.sh~" \
 --exclude "logfile_game.txt" --exclude "logfile_vnc.txt" \
 --exclude "Python-3.6.9.tgz" --exclude "rebuild.sh~" \
 --exclude "start_root_first.sh~" --exclude "start.sh~" \
 --exclude "test.log" --exclude "test.py~"\
 --exclude ".git" --exclude ".vscode"\
 "/media/sf_laGGer-dev/"  "/home/lagger/src" 

