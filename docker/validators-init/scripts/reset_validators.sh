#!/bin/bash

# Check if keys already exist
VALIDATOR_KEYS_FILE="/root/.ripple/validator-keys.json"
RIPPLED_CFG_FILE="/etc/opt/ripple/rippled.cfg"
VALIDATORS_FILE="/etc/opt/ripple/validators.txt"

if [ ! -f "$VALIDATOR_KEYS_FILE" ]; then
    /usr/local/bin/validator-keys create_keys
fi

if [ -f "/opt/ripple/etc/.build_flag" ]; then
    echo -e "[validators]\n" > "$VALIDATORS_FILE"
    rm -f /opt/ripple/etc/.build_flag
fi


EXISTING_TOKEN=$(awk '/\[validator_token\]/{getline; if ($0 != "") print $0}' $RIPPLED_CFG_FILE | awk 'NR>1')

if [ -z "$EXISTING_TOKEN" ]; then
    # No existing token found, generate new one
    echo "No existing validator token found. Generating new token..."
    VALIDATOR_DATA=$(/usr/local/bin/validator-keys create_token)
    VALIDATOR_PUBLIC_KEY=$(echo "$VALIDATOR_DATA" | awk -F": " '/validator public key/{print $2}')
    VALIDATOR_TOKEN=$(echo "$VALIDATOR_DATA" | awk '/\[validator_token\]/{flag=1; next} flag {print; if ($0 ~ /==$/) flag=0}')

    echo "Adding ${VALIDATOR_NAME} public key to validators.txt"
    echo "$VALIDATOR_PUBLIC_KEY" >> $VALIDATORS_FILE

    # Update rippled.cfg with validator token
    awk -v token="$VALIDATOR_TOKEN" '/\[validator_token\]/{print;print token;next}1' $RIPPLED_CFG_FILE > tmpfile && mv tmpfile $RIPPLED_CFG_FILE
fi

# Start rippled
exec /opt/ripple/bin/rippled "$@"

#while true; do sleep 3600; done
