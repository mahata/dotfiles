#!/bin/bash -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

run_install() {
  if [[ -n "$CODESPACES" ]]; then
    "$SCRIPT_DIR/install-codespaces.sh"
  else
    "$SCRIPT_DIR/install-local.sh"
  fi
}

# Log all output (stdout + stderr) to a file while still showing it on screen.
# A pipeline is used instead of `exec > >(tee ...)` process substitution because
# the shell waits for every command in a pipeline to finish, so tee always
# flushes the log before we exit. Process substitution children are not waited
# on and can be killed mid-flush, which left the log empty.
run_install 2>&1 | tee -i "$HOME/dotfiles_install.log"
exit "${PIPESTATUS[0]}"
