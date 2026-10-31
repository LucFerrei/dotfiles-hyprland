#!/usr/bin/env bash

killall -SIGUSR2 waybar

killall waybar && waybar &
