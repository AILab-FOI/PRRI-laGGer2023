import time
import subprocess

class VirtualSink:

    sinkName = None

    def __init__(self):
        VirtualSink.sinkName = 'VirtualSink' + str(int(time.time()))
        self.subprocess.run(["pacmd load-module module-null-sink sink_name=" + VirtualSink.sinkName])

    def __del__(self):
        sinkIndex = None
        listOfModules = self.subprocess.run(["pacmd list-modules"], capture_output=True, text=True)
        for line in listOfModules.split("\n"):
            if "index" in line:
                sinkIndex = line
            if VirtualSink.sinkName in line:
                break
        sinkIndex.replace("index: ", "")
        self.subprocess.run(["pactl unload-module " + sinkIndex])
