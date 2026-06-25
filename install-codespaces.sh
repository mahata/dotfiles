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

    local codename="unknown"
    if [[ -r /etc/os-release ]]; then
        codename="$(awk -F= '$1 == "VERSION_CODENAME" { print $2 }' /etc/os-release)"
    fi
    log_info "Detected Ubuntu codename: ${codename:-unknown}"

    # DPkg::Lock::Timeout lets apt wait for the dpkg lock instead of failing
    # immediately when unattended-upgrades runs during Codespace creation.
    sudo apt-get -o DPkg::Lock::Timeout=300 update \
        && sudo apt-get -o DPkg::Lock::Timeout=300 install -y software-properties-common \
        && sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs \
        && sudo apt-get -o DPkg::Lock::Timeout=300 update \
        && sudo apt-get -o DPkg::Lock::Timeout=300 install -y emacs-nox \
        || return 1

    if ! command -v emacs >/dev/null 2>&1; then
        log_error "Emacs binary not found after installation"
        return 1
    fi
    log_info "Installed $(emacs --version | head -n1)"
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
    run_step "Install Emacs 30" install_emacs
    run_step "Configure Zsh" configure_zsh
    run_step "Configure Git" configure_git
    run_step "Configure login shell" configure_login_shell
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
