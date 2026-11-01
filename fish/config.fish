if status is-interactive
    set --global fish_greeting

    fish_vi_key_bindings

    abbr --erase vi vim vimdiff cat ls 2>/dev/null
    abbr --add vi nvim
    abbr --add vim nvim
    abbr --add vimdiff "nvim -d"

    if command -sq bat
        abbr --add cat bat
    end
    if command -sq eza
        abbr --add ls "eza --grid --classify=always --no-quotes --group-directories-first --sort=name"
    end

    if command -sq fzf
        fzf --fish | source
        set --global --export FZF_DEFAULT_OPTS "--bind='ctrl-o:execute(nvim {})+abort'"
    end

    if command -sq starship
        starship init fish | source
    end
end
