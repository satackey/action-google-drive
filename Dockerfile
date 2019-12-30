FROM satackey/skicka

# RUN mv /root /github/home

WORKDIR /src
COPY entrypoint.sh ./
ENTRYPOINT /src/entrypoint.sh

WORKDIR /work
VOLUME ["/work"]