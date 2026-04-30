function ls --wraps=eza --description "List files with eza"
    if command -sq eza
        if test (count $argv) -eq 0
            command eza --grid --classify=always --no-quotes --group-directories-first --sort=name .
        else
            command eza --grid --classify=always --no-quotes --group-directories-first --sort=name $argv
        end
    else
        command ls $argv
    end
end
