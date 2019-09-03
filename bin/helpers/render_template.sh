#!/bin/sh
function render_template() {

  if [ ! -f docker-compose.yml ]; then
    echo "Please run this script from the root of the repo."
    exit 1
  fi

  eval "echo \"$(cat $1)\""
}
