#!/usr/bin/env bash

1password () {
  # capture all op:// in the environment
  OP_INPUT="$(printenv | grep "op://")"

  # exit early
  [[ -n "$OP_INPUT" ]] || return 0

  log_status "injecting 1password secrets"

  eval "$(echo "$OP_INPUT" | ${OP_CLI:-op} --account $OP_ACCOUNT inject | direnv dotenv bash /dev/stdin)"
}
