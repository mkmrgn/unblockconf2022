#!/bin/bash

function inline_image {
  printf '\033]1338;url='"$1"';alt='"$2"'\a\n'
}

inline_image $1 $2
