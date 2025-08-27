# ==========================
# Configuración inicial Zsh
# ==========================

# Autocompletado
autoload -Uz compinit
compinit

# Opciones útiles (suaves y no invasivas)
setopt autocd               # cd con solo escribir el directorio
setopt extendedglob         # patrones tipo **/*.txt
setopt hist_ignore_dups     # no repite consecutivos
setopt hist_ignore_all_dups # no repite ninguno
setopt share_history        # comparte historial entre sesiones
setopt inc_append_history   # escribe al historial en vivo

# Historial
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"

# PATH para NPM global
export PATH="$HOME/.npm-global/bin:$PATH"

# Alias comunes
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vultr='ssh root@64.176.221.22'

# Alias para zoxide
alias cd='z'  # usa zoxide en lugar de cd
alias cdi='zi'  # zoxide interactivo con fzf

# Prompt simple (usuario@host carpeta $)
PROMPT='[%n@%m %~]$ '

# ------- fzf (buscador interactivo) -------
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

# ------- zoxide (cd inteligente) -------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ------- Plugins -------
# Sugerencias en gris mientras escribes
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Colores de sintaxis en comandos (debe ir AL FINAL)
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh