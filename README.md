# Dotfiles

Mac setup: zsh (spaceship), tmux (tpm + tmux2k), neovim (LazyVim), alacritty, plus assorted tool configs.

## New Mac

```sh
xcode-select --install          # gives you git
git clone --recurse-submodules https://github.com/MaeverG/Dotfiles ~/Dotfiles
~/Dotfiles/install.sh
gh auth login
```

`install.sh` will:
1. Install Homebrew and everything in `Brewfile` (CLI tools, casks, Nerd Fonts)
2. Symlink each `config/<name>` to `~/.config/<name>` and `home/.zshenv` to `~/.zshenv`
   (anything already there is moved to `<name>.bak.<timestamp>`)
3. Copy `home/.gitconfig` if you don't already have one
4. Install tmux plugins via tpm

Then open `nvim` once so lazy.nvim installs its plugins, and set your terminal font to a Nerd Font.

## Layout

| Path | Goes to |
| --- | --- |
| `config/nvim` | `~/.config/nvim`, a submodule of [MaeverVim](https://github.com/MaeverG/MaeverVim) |
| `config/*` | `~/.config/*` (tmux, zsh, alacritty, htop, neofetch, flashspace, git) |
| `home/.zshenv` | `~/.zshenv` (sources `~/.config/zsh/.zshrc`) |
| `home/.gitconfig` | `~/.gitconfig` |
| `Brewfile` | `brew bundle` |

## Not included (on purpose)

`gh` credentials, shell history, tmux plugin clones (tpm reinstalls them), Raycast data, zsh caches.
Raycast: use its built-in Export/Import settings.

## Updating

Because configs are symlinked, edits made in `~/.config` are already in this repo; just commit.
nvim changes get committed in MaeverVim, then run `git add config/nvim` here to bump the submodule pointer.
Run `./sync.sh` to refresh the `Brewfile` (and copy configs if any aren't symlinked).
