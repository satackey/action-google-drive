#!/bin/sh

$UPLOAD_FROM_ABSOLUTE="$GITHUB_WORKSPACE/$UPLOAD_FROM"

echo $SKICKA_TOKENCACHE_JSON > /root/.skicka.tokencache.json

skicka upload -ignore-times "$UPLOAD_FROM_ABSOLUTE" "$UPLOAD_TO"

# Remove outdated
skicka -verbose download -ignore-times "$UPLOAD_TO" "$UPLOAD_FROM_ABSOLUTE" 2>&1 | \
    sed "/Downloaded and wrote/!d" | \
    sed -E "s/.*bytes to //" | \
    xargs -I{} skicka rm "$UPLOAD_FROM_ABSOLUTE/{}" || true