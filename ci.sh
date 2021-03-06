#!/bin/sh
set -ex # fail completely at first failure

NODE_ENV="test" gulp build

PORT=4321 node --harmony index.js &
NODE_PID=$!

PROXY_PORT=4041 --harmony node proxy.js &
PROXY_PID=$!

./node_modules/karma/bin/karma start karma.conf.coffee --single-run
TEST_RESULT=$?

set +e # don't worry about not being able to kill some processes

pkill -P $NODE_PID
kill $NODE_PID
kill $PROXY_PID

exit $TEST_RESULT
