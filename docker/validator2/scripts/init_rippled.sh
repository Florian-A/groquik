#!/bin/bash

/usr/local/bin/validator-keys create_keys

VALIDATOR_PUBLIC_KEY=$(validator-keys create_token | awk -F": " '/validator public key/{print $2}')
VALIDATOR_TOKEN=$(validator-keys create_token | awk '/\[validator_token\]/{flag=1; next} flag {print; if ($0 ~ /==$/) flag=0}')

echo $VALIDATOR_PUBLIC_KEY >> /opt/ripple/etc/validators.txt
awk -v token="$VALIDATOR_TOKEN" '/\[validator_token\]/{print;print token;next}1' /opt/ripple/etc/rippled.cfg > tmpfile && mv tmpfile /opt/ripple/etc/rippled.cfg

exec /opt/ripple/bin/rippled "$@"
#tail -f /dev/null