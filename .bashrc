eval "$(starship init bash)"

fastfetch

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/spulick/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/spulick/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac
# Tab completion for juliaup and julia channel selection
[ -f "/home/spulick/.julia/juliaup/completions/bash.sh" ] && source "/home/spulick/.julia/juliaup/completions/bash.sh"

# <<< juliaup initialize <<<

export PATH=~/bin:$PATH