#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# 🌐 WireGuard VPN Controls
alias vpn-on='sudo wg-quick up wg0 && echo "🟢 VPN Conectada (10.0.0.2)"'
alias vpn-off='sudo wg-quick down wg0 && echo "🔴 VPN Desconectada"' 
alias vpn-status='wg show && echo "📊 Red: 10.0.0.0/24"'
alias music-server='cd ~/shared-music && python3 -m http.server 8080 --bind 10.0.0.2 && echo "🎵 Música en http://10.0.0.2:8080"'

# 🌐 WireGuard VPN Controls
alias vpn-on='sudo wg-quick up wg0 && echo "🟢 VPN Conectada (10.0.0.2)"'
alias vpn-off='sudo wg-quick down wg0 && echo "🔴 VPN Desconectada"' 
alias vpn-status='wg show && echo "📊 Red: 10.0.0.0/24"'
alias music-server='cd ~/shared-music && python3 -m http.server 8080 --bind 10.0.0.2 && echo "🎵 Música en http://10.0.0.2:8080"'

# 🌐 WireGuard VPN Controls
alias vpn-on='sudo wg-quick up wg0 && echo "🟢 VPN Conectada (10.0.0.2)"'
alias vpn-off='sudo wg-quick down wg0 && echo "🔴 VPN Desconectada"' 
alias vpn-status='wg show && echo "📊 Red: 10.0.0.0/24"'
alias music-server='cd ~/shared-music && python3 -m http.server 8080 --bind 10.0.0.2 && echo "🎵 Música en http://10.0.0.2:8080"'
