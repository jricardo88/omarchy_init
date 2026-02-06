#!/bin/bash
DIR="/home/jerle/.config/omarchy/branding"

# 1. Buscamos el logo al azar
LOGO=$(ls "$DIR"/logo*.png | shuf -n 1)

# 2. Borramos el enlace anterior para evitar que Ghostty se confunda
rm -f "$DIR/current_logo.png"

# 3. Creamos el enlace nuevo usando rutas completas
ln -s "$LOGO" "$DIR/current_logo.png"

# 4. Ejecutamos fastfetch apuntando DIRECTO al config
fastfetch --config ~/.config/fastfetch/config.jsonc
