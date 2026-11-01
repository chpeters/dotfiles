# Dotfiles

## Bootstrap a Mac

Install Homebrew and Apple's command line tools first, then clone this repository
with submodules to `~/.dotfiles`. From that directory:

```sh
brew bundle --file=macos/Brewfile
./install
fish -c 'fisher update'
nvim --headless +qa
```

The Brewfile installs dependencies; Dotbot links configuration; Fisher restores
`fish/fish_plugins`; starting Neovim installs its declared plugins. Review the
Brewfile before running it on an existing machine: it installs the listed apps
and can upgrade installed packages. `fisher update` also updates existing plugins.

Conditional links preserve existing regular files and directories. If a link is
skipped, compare the existing configuration and move it aside before retrying.
In particular, an existing `~/.config/nvim` directory is never force-replaced.

Vite+ owns Node version selection. Install the global `vp` CLI using the
[official instructions](https://viteplus.dev/guide/global-cli), then run
`vp env on node`. Its installer creates the Fish shell integration.
Use `vp env current` to inspect resolution and `vp env pin node@VERSION` to
pin a project. Existing `.nvmrc` files are supported; nvm and mise are not needed.
Homebrew Node remains available for Homebrew dependencies.

Fish adds `~/.local/bin` for UV-installed tools. Vite+ maintains its own Fish
startup integration; install Vite+ to recreate it on a new machine.

To make Fish the login shell, run these commands from the current shell:

```sh
fish_path="$(brew --prefix)/bin/fish"
grep -qxF "$fish_path" /etc/shells || printf '%s\n' "$fish_path" | sudo tee -a /etc/shells
chsh -s "$fish_path"
```

Log out and back in for the login-shell change to take effect.

## Shell and workspaces

Start a new Fish shell after configuration changes. `cat` and `ls` abbreviate to
Bat and Eza only when typed interactively; scripts retain the original commands.
FZF's Ctrl-O opens the selected path in Neovim.

- `workspace`: create or reuse the Rex workspace (Neovim left, two shells right).
- Accepts `--reset` and `--name NAME`.

Install Rex Beta separately. Enable Settings → Rex Server → Remote Control for
scripted session selection and app-level resizing. Neovim must have started once
to install the backend used by `rex/init.lua`.

When migrating an older checkout, remove only the old dotfiles symlinks at
`~/.config/fish/functions/cat.fish` and `ls.fish`; the wrappers have been replaced
by abbreviations. Existing Fish processes may still have the old functions loaded.

## Generated artifacts and package snapshot

`./install` builds `macos/OpenMarkdownInNeovim.app` from its AppleScript source.
The generated app is ignored by Git; set it as your Markdown opener manually.

`macos/Brewfile` declares the intended setup. `macos/Brewfile.snapshot.json`
records the installed Homebrew formula and cask versions on the machine where
it was refreshed, including packages outside the Brewfile. It is an inventory,
not a version lock or a record of npm packages. After package changes, run:

```sh
python3 scripts/snapshot-homebrew.py
```
