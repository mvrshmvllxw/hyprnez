if status is-interactive
    set -g fish_greeting
    starship init fish | source
    alias ls 'lsd'
    krabby random
end