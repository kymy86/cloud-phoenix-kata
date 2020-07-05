FROM node:8-alpine
LABEL authors="michel" team="devops" version="1.0"

ARG NODE_ENV=development
ARG CHAMBER_VERSION=2.7.5

ENV CHAMBER_VERSION=${CHAMBER_VERSION} \
    NODE_ENV=${NODE_ENV}

#install chamber for injecting secrets from parameter store
RUN wget https://github.com/segmentio/chamber/releases/download/v${CHAMBER_VERSION}/chamber-v${CHAMBER_VERSION}-linux-amd64 -O /bin/chamber ;\
    chmod +x /bin/chamber

#create the home directory and set the node user as owner
RUN mkdir -p /usr/src/app ;\
    chown -R node:node /usr/src/app

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./

USER node

#installing npm packages
RUN npm install ;\
    npm cache clean --force --log-level=error

COPY --chown=node:node . .

EXPOSE 3000

CMD ["chamber", "exec", "phoenix-polimi", "--", "npm", "start"]