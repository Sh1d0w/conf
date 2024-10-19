# ----------------------------------------------------------------------------
# Aliases
# Common between POSIX shells such as bash and zsh.
# ----------------------------------------------------------------------------

# Only set aliases if FORCE flag is not set and sentinel alias exists.
if [ -z "${FORCE+x}" ] && command -v SH_ALIASES_SOURCED 1> /dev/null; then
    return 0
fi

echo "Setting aliases."

# NOTE: eza is an exa replacement.
if command -v eza 1> /dev/null; then
  alias ls="eza --icons --color-scale --group-directories-first"
  alias la="eza --long --all --icons --color-scale --group --header --group-directories-first"
  alias lg="eza --long --all --icons --color-scale --grid --group --header --group-directories-first"
elif command -v exa 1> /dev/null; then
  alias ls="exa --icons --color-scale --group-directories-first"
  alias la="exa --long --all --icons --color-scale --group --header --group-directories-first"
  alias lg="exa --long --all --icons --color-scale --grid --group --header --group-directories-first"
fi

alias SH_ALIASES_SOURCED="echo 0"
alias ..="cd .."
alias ...="cd ../.."
alias .2="cd ../.."
alias ....="cd ../../.."
alias .3="cd ../../.."
alias .....="cd ../../../.."
alias .4="cd ../../../.."
alias emc="emacsclient"
alias hit='git --git-dir="${HOME}/.git/" --work-tree="${HOME}"'

alias update="~/config/switch"

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'
alias cl='clear'
export SH_ALIASES_SOURCED=1
