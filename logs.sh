#!/usr/bin/env bash
set -m

docker-compose logs -f app |
  while IFS= read -r line
  do
    echo "$line"
    if echo "$line" | grep -q "fpm is running"; then kill $$; break;
  fi
  done;