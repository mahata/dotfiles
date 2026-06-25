# dotfiles

My personal dotfiles repository. `install.sh` detects the runtime environment and runs the appropriate setup, so the same repo works for both GitHub Codespaces and local machines (macOS / Linux).

## Installation

### Codespaces

Register this repository as your dotfiles in your GitHub account settings, and `install.sh` will run automatically whenever a Codespace starts.

Settings page: <https://github.com/settings/codespaces> — see the "Dotfiles" section.

The Codespaces setup also switches the login shell to `zsh` via `sudo chsh`, so new terminals start in zsh. It also installs Emacs 30 (`emacs-nox`) from the `ppa:ubuntuhandbook1/emacs` PPA, which provides Emacs 30 packages for Ubuntu 22.04 and 24.04.

### Local

```sh
git clone https://github.com/mahata/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` decides which setup to run based on whether the `CODESPACES` environment variable is set:

- If `CODESPACES` is set: runs `install-codespaces.sh`
- Otherwise: runs `install-local.sh`

## Logs

All output is printed to the terminal and also written to `$HOME/dotfiles_install.log`. Check that file when troubleshooting.

## Tests

Tests live in `tests/` and use [bats-core](https://github.com/bats-core/bats-core).

```sh
brew install bats-core   # or: apt-get install bats
bats tests/
```

CI runs three jobs on every push and pull request:

- `shellcheck` — lints the shell scripts.
- `bats` — unit tests with stubbed external commands.
- `integration` — runs `install.sh` inside the Codespaces base image (`mcr.microsoft.com/devcontainers/universal`) with `CODESPACES=true` and asserts the resulting shell, symlinks, and config.

## License

See [LICENSE](./LICENSE).
