FROM x11docker/xfce 
RUN apt-get update && apt-get install -y lskat 
RUN export PATH=$PATH:/usr/games/ 
ENV PATH="/usr/games/:${PATH}"
RUN mkdir -p /var/games/lskat && chmod -R 777 /var/games/lskat
