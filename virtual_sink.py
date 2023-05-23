import time
import subprocess
import re

#as of right now, this script isn't used anywhere, but it's functioning so don't delete it because it still might come in handy

class VirtualSink:

    sinkName = None
    sinkIndex = None
    greppingTheList = 'pacmd list-modules | grep -B 2 '

    def __init__(self):
        self.sinkName = 'VirtualSink' + str(int(time.time()))
        self.greppingTheList += self.sinkName + " | head -n 1"
        subprocess.run(["pacmd", "load-module", "module-null-sink", "sink_name=" + self.sinkName])
        capturedOutput = subprocess.run([self.greppingTheList], shell=True, capture_output=True, text=True)
        self.sinkIndex = capturedOutput.stdout
        self.sinkIndex = re.sub('\D', "", self.sinkIndex)


def DeleteSink(sinkIndex):
        subprocess.run(["pactl", "unload-module", sinkIndex])
