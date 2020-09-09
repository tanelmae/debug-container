alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias more=less

function test-tls() {
    openssl s_client -state -nbio -connect "${1}:${2}"
}

function test-tcp() {
    nc -z -v "${1}" "${2}"
}
