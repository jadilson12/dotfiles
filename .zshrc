# Archlinux Ultimate
# by jadilson12 and helmuthdu

# OVERALL CONDITIONALS {{{
_islinux=false
[[ "$(uname -s)" =~ Linux ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true
#}}}

# PACMAN ALIASES {{{
# we're on ARCH
if $_isarch; then
    # we're not root
    if ! $_isroot; then
        alias pacman='sudo pacman'
    fi
    alias pacupg='pacman -Syu'            # Synchronize with repositories and then upgrade packages that are out of date on the local system.
    alias pacupd='pacman -Sy'             # Refresh of all package lists after updating /etc/pacman.d/mirrorlist
    alias pacin='pacman -S'               # Install specific package(s) from the repositories
    alias pacinu='pacman -U'              # Install specific local package(s)
    alias pacre='pacman -R'               # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias pacun='pacman -Rcsn'            # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias pacinfo='pacman -Si'            # Display information about a given package in the repositories
    alias pacse='pacman -Ss'              # Search for package(s) in the repositories
    alias pacupa='pacman -Sy && sudo abs' # Update and refresh the local package and ABS databases against repositories
    alias pacind='pacman -S --asdeps'     # Install given package(s) as dependencies of another package
    alias pacclean="pacman -Sc"           # Delete all not currently installed package files
    alias pacmake="makepkg -fcsi"         # Make package from PKGBUILD file in current directory
    alias changemirror='svim /etc/pacman.d/mirrorlist'
fi
#}}}

# PRIVILEGED ACCESS {{{
if ! $_isroot; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
fi
#}}}

# MISC {{{
alias ls='ls -hF --color=auto'
alias l='ls -hF --color=auto'
alias lr='ls -R'      # recursive ls
alias ll='ls -alh'
alias la='ll -A'
alias lm='la | less'

# AUTOCOLOR {{{
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
#}}}

# MODIFIED COMMANDS {{{
alias ..='cd ..'
alias ....='cd ../..'
alias ......='cd ../../..'
alias df='df -h'
alias diff='colordiff'              # requires colordiff package
alias du='du -c -h'
alias free='free -m'                # show sizes in MB
alias grep='grep --color=auto'
alias grep='grep --color=tty -d skip'
alias mkdir='mkdir -p -v'
alias more='less'
alias nano='nano -w'
alias ping='ping -c 5'
alias exho='echo'
alias gcp='git cherry-pick'
#}}}

# LS {{{
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -alh'
alias la='ll -A'
alias lm='la | less'
#}}}


# CONFIG {{{
  export PATH=/usr/local/bin:$PATH
  if [[ -d "$HOME/bin" ]] ; then
      PATH="$HOME/bin:$PATH"
  fi

  # NVM {{{
    if [[ -f "/usr/share/nvm/nvm.sh" ]]; then
      source /usr/share/nvm/init-nvm.sh
    fi
  #}}}
  # ANDROID SDK {{{
    if [[ -d "/opt/android-sdk" ]]; then
      export ANDROID_HOME=/opt/android-sdk
    fi
  #}}}
  # CHROME {{{
    if which google-chrome-stable &>/dev/null; then
      export CHROME_BIN=/usr/bin/google-chrome-stable
    fi
  #}}}
  # EDITOR {{{
    if which vim &>/dev/null; then
      export EDITOR="vim"
    elif which emacs &>/dev/null; then
      export EDITOR="emacs -nw"
    else
      export EDITOR="nano"
    fi
  #}}}
  # COLORED MANUAL PAGES {{{
    # @see http://www.tuxarena.com/?p=508
    # For colourful man pages (CLUG-Wiki style)
    if $_isxrunning; then
      export PAGER=less
      export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
      export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
      export LESS_TERMCAP_me=$'\E[0m'           # end mode
      export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
      export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
      export LESS_TERMCAP_ue=$'\E[0m'           # end underline
      export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
    fi
  #}}}
  export ZSH=$HOME/.oh-my-zsh
  # Set name of the theme to load --- if set to "random", it will
  # load a random theme each time oh-my-zsh is loaded, in which case,
  # to know which specific one was loaded, run: echo $RANDOM_THEME
  # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

  ZSH_THEME="spaceship"
  plugins=(git)
  source $ZSH/oh-my-zsh.sh

  ### Added by Zplugin's installer
  source "$HOME/.zinit/bin/zplugin.zsh"
  autoload -Uz _zplugin
  (( ${+_comps} )) && _comps[zplugin]=_zplugin
  ### End of Zplugin's installer chunk

  zplugin light zdharma/fast-syntax-highlighting
  zplugin light zsh-users/zsh-autosuggestions
  zplugin light zsh-users/zsh-history-substring-search
  zplugin light zsh-users/zsh-completions
  zplugin light buonomo/yarn-completion

  pasteinit() {
      OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
      zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
  }

  pastefinish() {
      zle -N self-insert $OLD_SELF_INSERT
  }
  zstyle :bracketed-paste-magic paste-init pasteinit
  zstyle :bracketed-paste-magic paste-finish pastefinish

  SPACESHIP_PROMPT_ORDER=(
      user          # Username section
      dir           # Current directory section
      host          # Hostname section
      git           # Git section (git_branch + git_status)
      hg            # Mercurial section (hg_branch  + hg_status)
      exec_time     # Execution time
      line_sep      # Line break
      vi_mode       # Vi-mode indicator
      jobs          # Background jobs indicator
      exit_code     # Exit code section
      char          # Prompt character
  )
  SPACESHIP_USER_SHOW=always
  SPACESHIP_PROMPT_ADD_NEWLINE=false
  SPACESHIP_CHAR_SYMBOL="❯"
  SPACESHIP_CHAR_SUFFIX=" "
#}}}

# SYSTEMD SUPPORT {{{
if which systemctl &>/dev/null; then
    start() {
        sudo systemctl start $1.service
    }
    restart() {
        sudo systemctl restart $1.service
    }
    stop() {
        sudo systemctl stop $1.service
    }
    enable() {
        sudo systemctl enable $1.service
    }
    status() {
        sudo systemctl status $1.service
    }
    disable() {
        sudo systemctl disable $1.service
    }
fi
#}}}


# NVM {{{
if [[ -f "/usr/share/nvm/nvm.sh" ]]; then
    source /usr/share/nvm/init-nvm.sh
fi
#}}}

# ANDROID SDK {{{
if [[ -d "/opt/android-sdk" ]]; then
    export ANDROID_HOME=/opt/android-sdk
fi
#}}}

# CHROME {{{
if which google-chrome-stable &>/dev/null; then
    export CHROME_BIN=/usr/bin/google-chrome-stable
fi
#}}}


# FUNCTIONS {{{
  # BETTER GIT COMMANDS {{{
  bit() {
    # By helmuthdu
    usage(){
        echo "Usage: $0 [options]"
        echo "  --init                                              # Autoconfigure git options"
        echo "  a, [add] <files> [--all]                            # Add git files"
        echo "  c, [commit] <text> [--undo]                         # Add git files"
        echo "  C, [cherry-pick] <number> <url> [branch]            # Cherry-pick commit"
        echo "  b, [branch] feature|hotfix|<name>                   # Add/Change Branch"
        echo "  d, [delete] <branch>                                # Delete Branch"
        echo "  l, [log]                                            # Display Log"
        echo "  m, [merge] feature|hotfix|<name> <commit>|<version> # Merge branches"
        echo "  p, [push] <branch>                                  # Push files"
        echo "  P, [pull] <branch> [--foce]                         # Pull files"
        echo "  r, [release]                                        # Merge unstable branch on master"
        echo "  u, [release]                                        # undo comit"
        return 1
    }
    case $1 in
        --init)
            local NAME=`git config --global user.name`
            local EMAIL=`git config --global user.email`
            local USER=`git config --global github.user`
            local EDITOR=`git config --global core.editor`
            
            [[ -z $NAME ]] && read -p "Name: " NAME
            [[ -z $EMAIL ]] && read -p "Email: " EMAIL
            [[ -z $USER ]] && read -p "Username: " USER
            [[ -z $EDITOR ]] && read -p "Editor: " EDITOR
            
            git config --global user.name $NAME
            git config --global user.email $EMAIL
            git config --global github.user $USER
            git config --global color.ui true
            git config --global color.status auto
            git config --global color.branch auto
            git config --global color.diff auto
            git config --global diff.color true
            git config --global core.filemode true
            git config --global push.default matching
            git config --global core.editor $EDITOR
            git config --global format.signoff true
            git config --global alias.reset 'reset --soft HEAD^'
            git config --global alias.graph 'log --graph --oneline --decorate'
            git config --global alias.compare 'difftool --dir-diff HEAD^ HEAD'
            if which meld &>/dev/null; then
                git config --global diff.guitool meld
                git config --global merge.tool meld
                elif which kdiff3 &>/dev/null; then
                git config --global diff.guitool kdiff3
                git config --global merge.tool kdiff3
            fi
            git config --global --list
        ;;
        a | add)
            if [[ $2 == --all ]]; then
                git add -A
            else
                git add $2
            fi
        ;;
        b | branch )
            check_branch=`git branch | grep $2`
            case $2 in
                feature)
                    check_unstable_branch=`git branch | grep unstable`
                    if [[ -z $check_unstable_branch ]]; then
                        echo "creating unstable branch..."
                        git branch unstable
                        git push origin unstable
                    fi
                    git checkout -b feature --track origin/unstable
                ;;
                hotfix)
                    git checkout -b hotfix master
                ;;
                master)
                    git checkout master
                ;;
                *)
                    check_branch=`git branch | grep $2`
                    if [[ -z $check_unstable_branch ]]; then
                        echo "creating $2 branch..."
                        git branch $2
                        git push origin $2
                    fi
                    git checkout $2
                ;;
            esac
        ;;
        c | commit )
            if [[ $2 == --undo ]]; then
                git reset --soft HEAD^
            else
                git commit -am "$2"
            fi
        ;;
        C | cherry-pick )
            git checkout -b patch master
            git pull $2 $3
            git checkout master
            git cherry-pick $1
            git log
            git branch -D patch
        ;;
        d | delete)
            check_branch=`git branch | grep $2`
            if [[ -z $check_branch ]]; then
                echo "No branch founded."
            else
                git branch -D $2
                git push origin --delete $2
            fi
        ;;
        l | log )
            git log --graph --oneline --decorate
        ;;
        m | merge )
            check_branch=`git branch | grep $2`
            case $2 in
                --fix)
                    git mergetool
                ;;
                feature)
                    if [[ -n $check_branch ]]; then
                        git checkout unstable
                        git difftool -g -d unstable..feature
                        git merge --no-ff feature
                        git branch -d feature
                        git commit -am "${3}"
                    else
                        echo "No unstable branch founded."
                    fi
                ;;
                hotfix)
                    if [[ -n $check_branch ]]; then
                        # get upstream branch
                        git checkout -b unstable origin
                        git merge --no-ff hotfix
                        git commit -am "hotfix: v${3}"
                        # get master branch
                        git checkout -b master origin
                        git merge hotfix
                        git commit -am "Hotfix: v${3}"
                        git branch -d hotfix
                        git tag -a $3 -m "Release: v${3}"
                        git push --tags
                    else
                        echo "No hotfix branch founded."
                    fi
                ;;
                *)
                    if [[ -n $check_branch ]]; then
                        git checkout -b master origin
                        git difftool -g -d master..$2
                        git merge --no-ff $2
                        git branch -d $2
                        git commit -am "${3}"
                    else
                        echo "No unstable branch founded."
                    fi
                ;;
            esac
        ;;
        p | push )
            git push origin $2
        ;;
        P | pull )
            if [[ $2 == --force ]]; then
                git fetch --all
                git reset --hard origin/master
            else
                git pull origin $2
            fi
        ;;
        r | release )
            git checkout origin/master
            git merge --no-ff origin/unstable
            git branch -d unstable
            git tag -a $2 -m "Release: v${2}"
            git push --tags
        ;;
        *)
            usage
    esac
  }
#}}}
