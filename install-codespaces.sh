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

configure_zsh() {
    log_info "Configuring Zsh..."
    ln -sf "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
}

configure_git() {
    log_info "Configuring Git..."
    mkdir -p "$HOME/.config/git"
    ln -sf "$SCRIPT_DIR/git/config" "$HOME/.config/git/config"
}

log_info "Starting Codespaces installation..."
run_step "Install apt packages" install_apt_packages
run_step "Install uv" install_uv
run_step "Configure Zsh" configure_zsh
run_step "Configure Git" configure_git
