FROM ubuntu:22.04

COPY scripts/reset_validators.sh /usr/local/bin/reset_validators.sh
RUN chmod +x /usr/local/bin/reset_validators.sh

ENTRYPOINT ["/usr/local/bin/init_rippled.sh"]