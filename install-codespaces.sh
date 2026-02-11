#!/bin/bash -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

install_apt_packages() {
    sudo apt update
    sudo apt install -y \
        silversearcher-ag \
        httpie \
        vim
}

log_info "Starting Codespaces installation..."
run_step "Install apt packages" install_apt_packages
