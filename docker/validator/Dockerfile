FROM xrpllabsofficial/xrpld:latest

RUN apt-get update && apt-get install -y jq

COPY --from=local-validator-keys-tool:latest /usr/local/bin/validator-keys /usr/local/bin/

ARG VALIDATOR_NAME
ENV VALIDATOR_NAME=${VALIDATOR_NAME}

COPY config/rippled.cfg /opt/ripple/etc/rippled.cfg.template
COPY scripts/init_rippled.sh /usr/local/bin/init_rippled.sh
RUN chmod +x /usr/local/bin/init_rippled.sh

ENTRYPOINT ["/usr/local/bin/init_rippled.sh"]