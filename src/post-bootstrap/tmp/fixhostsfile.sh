#!/bin/bash

set -o xtrace
hostname=$(cat /etc/hostname)
cat /etc/hosts | sed -r -e "s/(\slocalhost)/\1 ${hostname}/g" > /tmp/newhosts
cp /tmp/newhosts /etc/hosts

