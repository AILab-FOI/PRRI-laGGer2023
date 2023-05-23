read Xenv < <(x11docker -f --pulseaudio --xdummy --size $3 --env="PULSE_SINK=$4" --showenv lagger/$1 $1)
env $Xenv x11vnc -noshm -forever -localhost -rfbport $2 -shared


#x11docker --cleanup
