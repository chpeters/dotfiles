function gg --description "Add all changes, commit, and push"
    git add --all
    and git commit $argv
    and git push
end
