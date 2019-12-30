#!/bin/sh

set -eu

# skicka init
echo $SKICKA_TOKENCACHE_JSON > $HOME/.skicka.tokencache.json

if [ -n "$GOOGLE_CLIENT_ID" ]; then
    sed -i -e "s/;clientid=YOUR_GOOGLE_APP_CLIENT_ID/clientid=$GOOGLE_CLIENT_ID/" ~/.skicka.config
    sed -i -e "s/;clientsecret=YOUR_GOOGLE_APP_SECRET/clientsecret=$GOOGLE_CLIENT_SECRET/" ~/.skicka.config
fi

skicka -no-browser-auth upload -ignore-times "$UPLOAD_FROM" "$UPLOAD_TO"

# Remove outdated
if [ $REMOVE_OUTDATED == "true" ]; then
    skicka -verbose download -ignore-times "$UPLOAD_TO" "$UPLOAD_FROM" 2>&1 | \
        sed "/Downloaded and wrote/!d" | \
        sed -E "s/.*bytes to //" | \
        xargs -I{} skicka rm "$UPLOAD_FROM{}" || true
elif [ $REMOVE_OUTDATED != "false" ]; then
    echo '$REMOVE_OUTDATED must be "true" or "false".'
    exit 1
fi
