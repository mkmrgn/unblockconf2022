#!/bin/bash

image_path=$1
image_alt=$2

function inline_image {
  printf '\033]1338;url='"$1"';alt='"$2"'\a\n'
}

inline_image $image_path $image_alt
