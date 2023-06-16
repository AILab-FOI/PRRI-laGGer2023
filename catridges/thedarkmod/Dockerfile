FROM x11docker/xfce 
COPY tdm_update.linux64 /game
RUN /game/tmd_update.linux64 --noselfupdate 
RUN export PATH=$PATH:/usr/games/ 
ENV PATH="/usr/games/:${PATH}"
