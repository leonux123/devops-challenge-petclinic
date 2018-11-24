#!/bin/bash

# Start admin
cd
java -jar poc/pocadmin.jar & echo $! > app.pid
echo "done"
exit 0;
