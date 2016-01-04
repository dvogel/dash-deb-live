#!/bin/bash
cd $(dirname $(readlink -f "$0"))
set -o xtrace
kver=$(ls -1 /lib/modules | head -n1)
[[ "$kver" != "" ]] && export KVER="${kver}" && make && make install

