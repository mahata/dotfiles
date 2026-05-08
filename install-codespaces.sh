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

configure_zsh() {
    log_info "Configuring Zsh..."
    ln -sf "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
}

configure_git() {
    log_info "Configuring Git..."
    mkdir -p "$HOME/.config/git"
    ln -sf "$SCRIPT_DIR/git/config" "$HOME/.config/git/config"
}

configure_login_shell() {
    log_info "Configuring login shell..."
    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ -z "$zsh_path" ]]; then
        echo "zsh not found, skipping login shell change"
        return 0
    fi

    local current_shell
    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
    if [[ "$current_shell" == "$zsh_path" ]]; then
        echo "Login shell is already $zsh_path, skipping"
        return 0
    fi

    sudo chsh -s "$zsh_path" "$USER"
}

main() {
    log_info "Starting Codespaces installation..."
    run_step "Install apt packages" install_apt_packages
    run_step "Install uv" install_uv
    run_step "Configure Zsh" configure_zsh
    run_step "Configure Git" configure_git
    run_step "Configure login shell" configure_login_shell
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
