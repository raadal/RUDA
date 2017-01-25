#!/bin/bash

while ! ip addr  show eth1 > /dev/null 2>&1; do
  #printf "."
  sleep 1
done

MY_IP=$(ip addr  show eth1 | grep 'inet ' | sed 's/.* \([0-9][0-9]*\.[0-9][0-9]*.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/')
echo $MY_IP
