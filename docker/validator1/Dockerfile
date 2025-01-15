
FROM xrpllabsofficial/xrpld:latest

COPY scripts/generate_keypairs.sh /usr/local/bin/generate_keypairs.sh
RUN chmod +x /usr/local/bin/generate_keypairs.sh

ENTRYPOINT ["/usr/local/bin/generate_keypairs.sh"]