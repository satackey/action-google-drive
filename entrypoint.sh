#!/bin/sh

set -eu

skicka init
echo $SKICKA_TOKENCACHE_JSON > $HOME/.skicka.tokencache.json

UPLOAD_FROM_ABSOLUTE="$GITHUB_WORKSPACE/$UPLOAD_FROM"

skicka upload -ignore-times "$UPLOAD_FROM_ABSOLUTE" "$UPLOAD_TO"

# Remove outdated
skicka -verbose download -ignore-times "$UPLOAD_TO" "$UPLOAD_FROM_ABSOLUTE" 2>&1 | \
    sed "/Downloaded and wrote/!d" | \
    sed -E "s/.*bytes to //" | \
    xargs -I{} skicka rm "$UPLOAD_FROM_ABSOLUTE/{}" || true