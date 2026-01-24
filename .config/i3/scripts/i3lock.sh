#!/bin/bash

#############################################
# PRE LOCK
#############################################

if pgrep -U $USER -x i3lock >/dev/null; then
  echo "Already locked"
  exit 0
fi

dunstctl set-paused true
i3-msg workspace 10

#############################################
# RUN LOCKER
#############################################

# catpuccin frappe
BLANK="00000000"
RED="e78284"
GREEN="a6d189"
BLUE="8caaee"
TEAL="81c8be"
MAUVE="ca9ee6"
SURFACE0="414559"
BASE="303446"
CRUST="232634"

i3lock \
  --nofork \
  --color=$CRUST"dd" \
  \
  --ignore-empty-password \
  --show-failed-attempts \
  \
  --radius=324 \
  --ring-width=32 \
  --inside-color=$BLANK \
  --ring-color=$BLUE"cc" \
  \
  --insidever-color=$GREEN"22" \
  --ringver-color=$GREEN"cc" \
  \
  --insidewrong-color=$RED"22" \
  --ringwrong-color=$RED"cc" \
  \
  --line-color=$BASE \
  --layout-color=$BLANK \
  --{keyhl,bshl,separator}-color=$TEAL"cc" \
  --{verif,wrong,modif,time,date}-color=$MAUVE \
  \
  --keylayout=0 \
  --time-str="%I:%M %Z" \
  --date-str="%A, %B %d" \
  --verif-text="Verifying" \
  --wrong-text="Wrong!" \
  --noinput-text="No input" \
  \
  --time-size=48 \
  --date-size=48 \
  --verif-size=64 \
  --wrong-size=64 \
  --modif-size=36 \
  \
  --ind-pos="x+0.5*w:y+0.4*h" \
  --date-pos="ix:iy-0.2*r" \
  --wrong-pos="ix:iy-0.1*r" \
  --verif-pos="ix:iy-0.1*r" \
  --modif-pos="ix:iy+0.1*r" \
  --time-pos="ix:iy+0.4*r"

#############################################
# POST LOCK
#############################################

dunstctl set-paused false
