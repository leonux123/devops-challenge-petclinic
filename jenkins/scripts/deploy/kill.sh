#!/bin/bash

# Kill admin pid
kill -9 `cat app.pid`
echo "done"
exit 0;
