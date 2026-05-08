# dotfiles

My personal dotfiles repository. `install.sh` detects the runtime environment and runs the appropriate setup, so the same repo works for both GitHub Codespaces and local machines (macOS / Linux).

## Installation

### Codespaces

Register this repository as your dotfiles in your GitHub account settings, and `install.sh` will run automatically whenever a Codespace starts.

Settings page: <https://github.com/settings/codespaces> — see the "Dotfiles" section.

The Codespaces setup also switches the login shell to `zsh` via `sudo chsh`, so new terminals start in zsh.

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

## License

See [LICENSE](./LICENSE).
