FROM node:7.10.1

MAINTAINER Unai Martinez <u.martinez@epages.com>

RUN mkdir -p /app

WORKDIR /app

COPY . .

RUN npm install

RUN npm install -g gulp

CMD ./bootstart.sh
