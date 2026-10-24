# Append to the end of ~/.bashrc (install.sh does this for you).
export PATH="$HOME/.local/bin:$PATH"

# Ghostty intro: sandevistan ring + system info + Matrix/Edgerunners quote (remove to disable)
if [[ $- == *i* && $TERM_PROGRAM == ghostty && -z $TERM_INTRO_SHOWN ]] && command -v edgerunner-fetch >/dev/null; then
    export TERM_INTRO_SHOWN=1
    edgerunner-fetch
fi

# Starship prompt (config: ~/.config/starship.toml)
command -v starship >/dev/null && eval "$(starship init bash)"
