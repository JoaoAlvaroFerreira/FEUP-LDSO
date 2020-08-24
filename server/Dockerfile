FROM node:12

WORKDIR /server
COPY package.json /server
COPY package-lock.json /server

RUN npm ci
COPY . /server

CMD npm start
