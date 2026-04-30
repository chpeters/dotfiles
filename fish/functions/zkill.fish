function zkill --description "Kill and delete all Zellij sessions"
    if not command -sq zellij
        echo "zkill: zellij is not installed" >&2
        return 127
    end

    zellij delete-all-sessions --yes --force $argv
end
