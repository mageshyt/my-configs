if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
alias cls="clear"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/magesh/anaconda3/bin/conda
    eval /Users/magesh/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
set -gx MAMBA_EXE "/Users/magesh/.micromamba/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/Users/magesh/micromamba"
eval "/Users/magesh/.micromamba/bin/micromamba" shell hook --shell fish --prefix "/Users/magesh/micromamba" | source
# <<< mamba initialize <<<
