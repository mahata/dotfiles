#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    # shellcheck source=../install-codespaces.sh
    source "$REPO_ROOT/install-codespaces.sh"
    sudo() { echo "SUDO_CALL: $*"; }
    emacs() { echo "GNU Emacs 30.1"; }
    export -f sudo emacs
}

@test "adds the emacs PPA and installs emacs-nox" {
    run install_emacs
    [ "$status" -eq 0 ]
    [[ "$output" == *"SUDO_CALL: add-apt-repository -y ppa:ubuntuhandbook1/emacs"* ]]
    [[ "$output" == *"SUDO_CALL: apt-get -o DPkg::Lock::Timeout=300 install -y emacs-nox"* ]]
}

@test "ensures software-properties-common is installed" {
    run install_emacs
    [ "$status" -eq 0 ]
    [[ "$output" == *"SUDO_CALL: apt-get -o DPkg::Lock::Timeout=300 install -y software-properties-common"* ]]
}

@test "verifies the installed emacs version" {
    run install_emacs
    [ "$status" -eq 0 ]
    [[ "$output" == *"Installed GNU Emacs 30.1"* ]]
}
