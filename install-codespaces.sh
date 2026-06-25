#!/bin/bash -x

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
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

install_emacs() {
    log_info "Installing Emacs 30..."
    sudo apt update \
        && sudo apt install -y software-properties-common \
        && sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs \
        && sudo apt update \
        && sudo apt install -y emacs-nox
}

configure_git() {
    log_info "Configuring Git..."
    mkdir -p "$HOME/.config/git"
    ln -sf "$SCRIPT_DIR/git/config" "$HOME/.config/git/config"
}

main() {
    log_info "Starting Codespaces installation..."
    run_step "Install apt packages" install_apt_packages
    run_step "Install uv" install_uv
    run_step "Install Emacs 30" install_emacs
    run_step "Configure Git" configure_git
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
