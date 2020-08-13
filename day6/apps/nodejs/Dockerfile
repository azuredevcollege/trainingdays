# source: https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
FROM node:12

# Create app directory
WORKDIR /usr/src/app

# Copy source files
COPY package.json .
COPY server.js .

# Install app dependencies
RUN npm install

# Exposing the port 8080
EXPOSE 8080

CMD [ "node", "server.js" ]