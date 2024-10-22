if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -g fish_greeting
alias ls 'lsd'
starship init fish | source
