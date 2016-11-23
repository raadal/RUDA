#!/bin/bash
cat /etc/hosts | grep $(hostname) | tail -n 1 | cut  -f1
