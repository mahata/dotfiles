#!/bin/bash -x

# Log all output (stdout) and also show it on screen
exec > >(tee -i "$HOME/dotfiles_install.log")
exec 2>&1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ -n "$CODESPACES" ]]; then
  "$SCRIPT_DIR/install-codespaces.sh"
else
  "$SCRIPT_DIR/install-local.sh"
fi
