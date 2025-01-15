#!/bin/bash

RIPPLED_DIR="/opt/ripple"
CONFIG_DIR="/config"
KEYS_FILE="$CONFIG_DIR/validator-keys.json"
VALIDATORS_FILE="$CONFIG_DIR/validators.txt"

$RIPPLED_DIR/bin/rippled "$@" &
RIPPLED_PID=$!

sleep 2
$RIPPLED_DIR/bin/rippled validation_create > $KEYS_FILE
kill $RIPPLED_PID

VALIDATION_PUBLIC_KEY=$(jq -r '.result.validation_public_key' $KEYS_FILE)

echo "[validators]" > $VALIDATORS_FILE
echo "$VALIDATION_PUBLIC_KEY" >> $VALIDATORS_FILE

exec $RIPPLED_DIR/bin/rippled "$@" --conf "$CONFIG_DIR/rippled.cfg" 