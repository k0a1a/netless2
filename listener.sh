#!/bin/sh

hexinject-min -s -t 10000 -P -l 384 -i wlan0 | awk -f beacon.awk
