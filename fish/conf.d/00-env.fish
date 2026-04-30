if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
else if test -x /usr/local/bin/brew
    /usr/local/bin/brew shellenv fish | source
end

set --global --export EDITOR nvim
set --global --export BUN_INSTALL "$HOME/.bun"
set --global nvm_data "$HOME/.nvm/versions/node"

fish_add_path --global --move --path \
    "$HOME/.antigravity/antigravity/bin" \
    "$BUN_INSTALL/bin" \
    "$HOME/.gem/ruby/2.6.0/bin"

fish_add_path --global --append --path "$HOME/bin"
