#!/bin/sh
set -ex
PORT=4321 npm start &
NODE_PID=$!

node proxy.js &
PROXY_PID=$!
./node_modules/karma/bin/karma start karma.conf.coffee --single-run

kill $NODE_PID
kill $PROXY_PID
