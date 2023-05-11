function getQueryVar(name, defVal) {
    "use strict";
    const varString = atob(document.location.href.match(/token=([A-Za-z0-9._-]*)/)[0].substring(6));
    const re = new RegExp('.*[?&]' + name + '=([^&#]*)'),
        match = varString.match(re);
    if (typeof defVal === 'undefined') { defVal = null; }

    if (match) {
        return decodeURIComponent(match[1]);
    }

    return defVal;
}
/*
const regex = new RegExp("\b(?:\d{1,3}\.){3}\d{1,3}\b");
const url = window.location.href;
const match = regex.exec(url);
const ip = match;*/


var textroom_handle;
var textroom_id = parseInt(2);
var opaqueId = "textroomtest-" + Janus.randomString(12);
var JanusText = null;
var myid = Janus.randomString(12);
username = getQueryVar('user');

var participants = {};
var transactions = {};
server_host = getQueryVar('janus_host');
server_port = getQueryVar('janus_port');
//TODO: FIX GET QUERY FOR IP
server = "https://" + "192.168.222.11" + ":8089" + "/janus";
console.log(server);

$(document).ready(function () {
    /* // Initialize the library (all console debuggers enabled)
     Janus.init(
     {
         debug: "all", callback: function () 
         {
              // Use a button to start the demo*/
    $('#startchat').one('click', () => {
        // Make sure the browser supports WebRTC
        if (!Janus.isWebrtcSupported()) {
            bootbox.alert("Your browser doesn't support text streaming!");
            return;
        }
        JanusText = new Janus(
            {
                server: server,
                success: function () {
                    JanusText.attach(
                        {
                            plugin: "janus.plugin.textroom",
                            opaqueId: opaqueId,
                            success: (pluginHandle) => {
                                textroom_handle = pluginHandle;
                                console.log("Plugin attached! (" + textroom_handle.getPlugin() + ", id=" + textroom_handle.getId() + ")");
                                var body = { request: "setup" };
                                console.log("Sending message:", body);
                                textroom_handle.send({ message: body });
                            },
                            error: function (error) {
                                console.error("  -- Error attaching plugin...", error);
                                bootbox.alert("Error attaching plugin... " + error);
                            },
                            iceState: function (state) {
                                console.log("ICE state changed to " + state);
                            },
                            mediaState: function (medium, on) {
                                console.log("Janus " + (on ? "started" : "stopped") + " receiving our " + medium);
                            },
                            webrtcState: function (on) {
                                console.log("Janus says our WebRTC PeerConnection is " + (on ? "up" : "down") + " now");
                                registerTextUsername();
                            },
                            ondata: (data) => {
                                var json = JSON.parse(data);
                                console.log(json);
                                var transaction = json["transaction"];
                                if (transactions[transaction]) {
                                    // Someone was waiting for this
                                    transactions[transaction](json);
                                    delete transactions[transaction];
                                    return;
                                }
                                var what = json["textroom"];
                                if (what === "message") {
                                    // Incoming message: public or private?
                                    var msg = json["text"];
                                    msg = msg.replace(new RegExp('<', 'g'), '&lt');
                                    msg = msg.replace(new RegExp('>', 'g'), '&gt');
                                    var from = json["from"];
                                    // var dateString = getDateString(json["date"]);
                                    var whisper = json["whisper"];
                                    console.log("its a message");
                                    if (whisper === true) {
                                        // Private message
                                        console.log("a private message");
                                        document.querySelector('#chatroom').append('<p>[' + '-->' + '] <b>[whisper from ' + participants[from] + ']</b> ' + msg);
                                    }
                                    else {
                                        // Public message
                                        console.log("a public message");
                                        document.querySelector('#chatroom').append(from + ' : ' + msg);
                                    }
                                }
                                else if (what === "join") {
                                    // Somebody joined
                                    console.log("Someone joined.");
                                }
                            },
                            onmessage: function (msg, jsep) {
                                console.log(" ::: Got a message :::", msg);
                                if (msg["error"]) {
                                    console.log(msg["error"]);
                                }
                                if (jsep) {
                                    // Answer
                                    textroom_handle.createAnswer(
                                        {
                                            jsep: jsep,
                                            // We only use datachannels
                                            tracks: [
                                                { type: 'data' }
                                            ],
                                            success: function (jsep) {
                                                console.log("Got SDP!", jsep);
                                                let body = { request: "ack" };
                                                textroom_handle.send({ message: body, jsep: jsep });
                                            },
                                            error: function (error) {
                                                console.log("WebRTC error:", error);
                                            }
                                        });
                                }
                            },
                        });
                },
                error: function (error) {
                    Janus.error(error);
                    bootbox.alert(error, function () {
                        //window.location.reload();
                    });
                    console.log(error);
                },
            });
    });
    //}});    
});

function registerTextUsername() {
    username = getQueryVar('user'); // TODO: get this from server
    console.log(username);
    let transaction = Janus.randomString(12);
    let register = {
        textroom: "join",
        transaction: transaction,
        room: textroom_id,
        username: myid,
        display: username
    };
    //myusername = username;
    textroom_handle.data({
        text: JSON.stringify(register),
        error: function (reason) {
            bootbox.alert(reason);
        }
    });
}

function sendTextData() {
    let data = $('#datasend').val();
    let message = {
        textroom: "message",
        transaction: Janus.randomString(12),
        room: textroom_id,
        text: data,
    };
    // Note: messages are always acknowledged by default. This means that you'll
    // always receive a confirmation back that the message has been received by the
    // server and forwarded to the recipients. If you do not want this to happen,
    // just add an ack:false property to the message above, and server won't send
    // you a response (meaning you just have to hope it succeeded).
    textroom_handle.data({
        text: JSON.stringify(message),
        error: function (reason) {
            bootbox.alert(reason);
            console.log("Upsic.");
        },
        success: function () {
            $('#datasend').val('');
            console.log("Poslano");
        }
    });
}

function checkEnter(field, event) {
    let theCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
    if (theCode == 13) {
        if (field.id == 'datasend') {
            sendTextData();
        }
        return false;
    }
    else {
        return true;
    }
}
