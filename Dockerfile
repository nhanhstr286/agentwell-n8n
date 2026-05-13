FROM n8nio/n8n:1.19.4

USER root

RUN mkdir -p /home/node/.n8n \
    && chown -R node:node /home/node \
    && chmod -R 755 /home/node/.n8n

USER node

EXPOSE 5678
