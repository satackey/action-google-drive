FROM satackey/skicka

WORKDIR /src
COPY entrypoint.sh ./
ENTRYPOINT /src/entrypoint.sh

WORKDIR /work
VOLUME ["/work"]