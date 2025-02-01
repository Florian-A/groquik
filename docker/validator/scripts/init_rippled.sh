#!/bin/bash

# Check if keys already exist
KEYS_FILE="/opt/ripple/shared/keys/${VALIDATOR_NAME}_keys.json"
mkdir -p /opt/ripple/shared/keys

if [ ! -f "$KEYS_FILE" ]; then
    echo "Generating new validator keys for ${VALIDATOR_NAME}"
    /usr/local/bin/validator-keys create_keys
    cp validator-keys.json "$KEYS_FILE"
else
    echo "Using existing validator keys for ${VALIDATOR_NAME}"
    cp "$KEYS_FILE" validator-keys.json
fi

# Generate token and get public key
VALIDATOR_DATA=$(/usr/local/bin/validator-keys create_token)
VALIDATOR_PUBLIC_KEY=$(echo "$VALIDATOR_DATA" | awk -F": " '/validator public key/{print $2}')
VALIDATOR_TOKEN=$(echo "$VALIDATOR_DATA" | awk '/\[validator_token\]/{flag=1; next} flag {print; if ($0 ~ /==$/) flag=0}')

# Update validators.txt if public key not already present
if ! grep -q "$VALIDATOR_PUBLIC_KEY" /opt/ripple/shared/validators.txt; then
    echo "Adding ${VALIDATOR_NAME} public key to validators.txt"
    echo "$VALIDATOR_PUBLIC_KEY" >> /opt/ripple/shared/validators.txt
fi

# Create rippled.cfg with the correct configuration
cp /opt/ripple/etc/rippled.cfg.template /opt/ripple/etc/rippled.cfg

# Update rippled.cfg with validator token
awk -v token="$VALIDATOR_TOKEN" '/\[validator_token\]/{print;print token;next}1' /opt/ripple/etc/rippled.cfg > tmpfile && mv tmpfile /opt/ripple/etc/rippled.cfg

# Update fixed IPs configuration
sed -i "s/\[ips_fixed\]/[ips_fixed]\nvalidator1 51235\nvalidator2 51235/" /opt/ripple/etc/rippled.cfg

# Start rippled
exec /opt/ripple/bin/rippled "$@"