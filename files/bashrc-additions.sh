# Ghostty intro: ink-wash moon + fastfetch system info + quote (remove to disable)
if [[ $- == *i* && $TERM_PROGRAM == ghostty && -z $TERM_INTRO_SHOWN ]] && command -v term-intro >/dev/null; then
    export TERM_INTRO_SHOWN=1
    term-intro
fi

# Starship prompt (config: ~/.config/starship.toml)
command -v starship >/dev/null && eval "$(starship init bash)"
