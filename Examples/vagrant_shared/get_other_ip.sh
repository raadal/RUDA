#!/bin/bash

cat /etc/hosts | grep $1 | tail -n 1 | cut  -f1
