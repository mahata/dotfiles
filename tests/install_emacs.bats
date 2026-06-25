#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    # shellcheck source=../install-codespaces.sh
    source "$REPO_ROOT/install-codespaces.sh"

    sudo() { echo "SUDO_CALL: $*"; }
    add-apt-repository() { echo "ADD_APT_REPOSITORY_CALL: $*"; }
    export -f sudo add-apt-repository
}

@test "adds the emacs PPA and installs emacs-nox" {
    run install_emacs
    [ "$status" -eq 0 ]
    [[ "$output" == *"SUDO_CALL: add-apt-repository -y ppa:ubuntuhandbook1/emacs"* ]]
    [[ "$output" == *"SUDO_CALL: apt install -y emacs-nox"* ]]
}

@test "ensures software-properties-common is installed" {
    run install_emacs
    [ "$status" -eq 0 ]
    [[ "$output" == *"SUDO_CALL: apt install -y software-properties-common"* ]]
}
