#!/bin/bash

link_url=$1

function inline_link {
  LINK=$(printf "url='%s'" "$1")

  if [ $# -gt 1 ]; then
    LINK=$(printf "$LINK;content='%s'" "$2")
  fi

  printf '\033]1339;%s\a\n' "$LINK"
}

inline_link $link_url
