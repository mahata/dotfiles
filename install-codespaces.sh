#!/bin/bash -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

install_uv() {
    log_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_apt_packages() {
    sudo apt update
    sudo apt install -y \
        silversearcher-ag \
        httpie \
        vim \
        shellcheck
}

log_info "Starting Codespaces installation..."
run_step "Install apt packages" install_apt_packages
