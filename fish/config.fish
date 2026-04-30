if status is-interactive
    set --global fish_greeting

    fish_vi_key_bindings

    abbr --erase vi vim vimdiff cat ls 2>/dev/null
    abbr --add vi nvim
    abbr --add vim nvim
    abbr --add vimdiff "nvim -d"

    if command -sq fzf
        fzf --fish | source
        set --global --export FZF_DEFAULT_OPTS "--bind='ctrl-o:execute(code {})+abort'"
    end

    if command -sq starship
        starship init fish | source
    end
end
