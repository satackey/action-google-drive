#!/bin/sh

set -eu

skicka init
echo $SKICKA_TOKENCACHE_JSON > $HOME/.skicka.tokencache.json

skicka upload -ignore-times "$UPLOAD_FROM" "$UPLOAD_TO"

# Remove outdated
skicka -verbose download -ignore-times "$UPLOAD_TO" "$UPLOAD_FROM" 2>&1 | \
    sed "/Downloaded and wrote/!d" | \
    sed -E "s/.*bytes to //" | \
    xargs -I{} skicka rm "$UPLOAD_FROM/{}" || true