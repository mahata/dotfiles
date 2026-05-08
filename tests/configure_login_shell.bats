#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    # shellcheck source=../install-codespaces.sh
    source "$REPO_ROOT/install-codespaces.sh"

    export USER="testuser"
    STUB_ZSH_PATH="/usr/bin/zsh"
    STUB_CURRENT_SHELL="/bin/bash"

    command() {
        if [[ "$1" == "-v" && "$2" == "zsh" ]]; then
            [[ -n "$STUB_ZSH_PATH" ]] && echo "$STUB_ZSH_PATH"
            [[ -n "$STUB_ZSH_PATH" ]]
            return $?
        fi
        builtin command "$@"
    }
    getent() {
        if [[ "$1" == "passwd" && "$2" == "$USER" ]]; then
            echo "$USER:x:1000:1000::/home/$USER:$STUB_CURRENT_SHELL"
            return 0
        fi
        return 2
    }
    sudo() { echo "SUDO_CALL: $*"; }
    export -f command getent sudo
}

@test "changes login shell when current shell is bash" {
    STUB_CURRENT_SHELL="/bin/bash"
    run configure_login_shell
    [ "$status" -eq 0 ]
    [[ "$output" == *"SUDO_CALL: chsh -s /usr/bin/zsh testuser"* ]]
}

@test "skips chsh when login shell is already zsh" {
    STUB_CURRENT_SHELL="/usr/bin/zsh"
    run configure_login_shell
    [ "$status" -eq 0 ]
    [[ "$output" == *"already"* ]]
    [[ "$output" != *"SUDO_CALL"* ]]
}

@test "skips when zsh is not installed" {
    STUB_ZSH_PATH=""
    run configure_login_shell
    [ "$status" -eq 0 ]
    [[ "$output" == *"zsh not found"* ]]
    [[ "$output" != *"SUDO_CALL"* ]]
}
