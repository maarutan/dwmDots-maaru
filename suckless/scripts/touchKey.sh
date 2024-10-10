#!/bin/sh
pkill picom
warpd --hint --oneshot; warpd --click 1
picom &
