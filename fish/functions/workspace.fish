function workspace --description "Open the work Zellij workspace"
    set --local session work
    set --local layout work
    set --local reset false

    for arg in $argv
        switch $arg
            case --reset reset
                set reset true
            case '*'
                echo "usage: workspace [--reset]" >&2
                return 2
        end
    end

    if not command -sq zellij
        echo "workspace: zellij is not installed" >&2
        return 127
    end

    if test $reset = true
        if set --query ZELLIJ
            echo "workspace: detach or exit Zellij before resetting the work session" >&2
            return 1
        end

        zellij delete-session --force $session >/dev/null 2>&1
    end

    if set --query ZELLIJ
        zellij action new-tab --layout $layout --name $session
        return $status
    end

    set --local session_line (zellij list-sessions --no-formatting 2>/dev/null | string match "$session *")

    if string match -q "*EXITED*" -- $session_line
        zellij delete-session --force $session >/dev/null 2>&1
        set session_line
    end

    if test (count $session_line) -gt 0
        zellij attach --force-run-commands $session
    else
        zellij attach --create $session options --default-layout $layout
    end
end
