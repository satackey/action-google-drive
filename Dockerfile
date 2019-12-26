FROM satackey/skicka

WORKDIR /github
RUN mv /root ./home

WORKDIR /src
COPY entrypoint.sh ./
ENTRYPOINT /src/entrypoint.sh

WORKDIR /work
VOLUME ["/work"]