function cat --wraps=bat --description "Print files with bat"
    if command -sq bat
        command bat $argv
    else
        command cat $argv
    end
end
