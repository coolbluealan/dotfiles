#!/usr/bin/env bash

# Terminate running bar
polybar-msg cmd quit

# Launch bar
LOG=/tmp/polybar.log
echo "---" >>$LOG
polybar --reload &>>$LOG
