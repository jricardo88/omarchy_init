# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# uv
export PATH="/home/jerle/.local/share/../bin:$PATH"
export PATH="$HOME/Proyectos/omarchy_init/scripts:$PATH"
#fastfetch | tte slide

# --- DASHBOARD DE INICIO PARA JERLE ---

function status_jerle() {
    # 1. Recopilación de datos básicos
    FECHA=$(date '+%A, %d de %B')
    HORA=$(date '+%H:%M')
    RAM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    DISCO=$(df -h / | awk 'NR==2 {print $4}')
    UPDATES=$(checkupdates 2>/dev/null | wc -l || echo "0")
    PING=$(ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "SI" || echo "NO")

    # 2. Sensores (Temperatura y Batería)
    # Temperatura del CPU
    TEMP=$(sensors 2>/dev/null | grep -E 'Package id 0|Core 0|Tctl' | head -n 1 | awk '{print $4}' | sed 's/+//' | tr -d '()')
    [ -z "$TEMP" ] && TEMP="N/A"

    # Lógica de Batería: Traducir estado a Enchufado/Desenchufado
    BATT_PCT=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)%
    RAW_STAT=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)

    # Obtener MB descargados (suponiendo que tu interfaz es wlan0)
    RX_BYTES=$(cat /sys/class/net/wlan0/statistics/rx_bytes 2>/dev/null || echo 0)
    RX_MB=$((RX_BYTES / 1024 / 1024))
    
    if [[ "$RAW_STAT" == "Charging" || "$RAW_STAT" == "Full" ]]; then
        BATT_STAT="Enchufado"
    else
        BATT_STAT="Desenchufado"
    fi
    BATERIA="$BATT_PCT ($BATT_STAT)"

    # 3. Diseño Visual Organizado
    INFO_SISTEMA="
  -----------------------------------------------------------
  SISTEMA: $(hostname) | USUARIO: $(whoami) | NET: $PING
  RECURSOS: RAM: $RAM | DISCO: $DISCO | UPD: $UPDATES
  SENSORS: TEMP: $TEMP | BAT: $BATERIA
  DATOS: ${RX_MB} MB bajados
  $FECHA | $HORA
  -----------------------------------------------------------
"
    echo -e "$INFO_SISTEMA"
}

# --- EJECUCIÓN Y ALIAS ---
alias status='status_jerle'
status_jerle
