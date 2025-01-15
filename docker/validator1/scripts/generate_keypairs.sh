#!/bin/bash

RIPPLED_DIR="/opt/ripple"
CONFIG_DIR="/config"
KEYS_FILE="$CONFIG_DIR/validator-keys.json"
VALIDATORS_FILE="$CONFIG_DIR/validators.txt"

exec $RIPPLED_DIR/bin/rippled "$@" &
RIPPLED_PID=$!

sleep 10

exec $RIPPLED_DIR/bin/rippled validation_create > $KEYS_FILE

VALIDATION_PUBLIC_KEY=$(jq -r '.result.validation_public_key' $KEYS_FILE)

echo "Clé publique extraite : $VALIDATION_PUBLIC_KEY"

echo "$VALIDATION_PUBLIC_KEY" >> $VALIDATORS_FILE
echo "Clé publique ajoutée au fichier validators.txt."

kill $RIPPLED_PID
wait $RIPPLED_PID

exec $RIPPLED_DIR/bin/rippled --conf "$CONFIG_DIR/rippled.cfg" "$@"