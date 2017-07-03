#!/bin/bash
./usr/local/bin/wait.sh -t 20 -h mongodb -p 27017

cd /usr/src/app && npm start

