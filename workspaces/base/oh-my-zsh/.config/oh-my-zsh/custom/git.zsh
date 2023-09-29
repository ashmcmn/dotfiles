alias gcu="git branch --merged | egrep -v '(^\\*|main|master|staging)' | xargs git branch -d"
