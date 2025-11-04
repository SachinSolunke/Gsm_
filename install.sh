#!/bin/bash
# ==============================================================================
# 🔥 PROJECT SARVA-VYAPI - The "Shuddh-Lekhan" Installer v3.0 🔥
# Ek astra jo apne aadesh saaf-saaf likhta hai.
#
# By The Emperor (Sachin Solunke) & his Senapati, Jarvis. ❤️
# ==============================================================================

# --- CONFIGURATION ---
REPO_OWNER="SachinSolunke"
REPO_NAME="Gsm_"
MAIN_SCRIPT="main.py"
INSTALL_NAME="gsm"

# --- FUNCTIONS ---
# ... (show_progress waisa hi) ...

# --- DIVYA-DRISHTI (ENVIRONMENT DETECTION) ---
clear
echo "======================================================"
echo "🔱 Sarva-Vyapi Astra Sthapna Shuru Ho Rahi Hai... 🔱"
echo "======================================================"

OS_TYPE=$(uname -o)
# ... (Baaki saara environment detection waisa hi) ...
PYTHON_PATH=$(command -v python3 || command -v python)

# --- UNIVERSAL INSTALLATION STEPS ---
# ... (Baaki saare installation steps waise hi) ...

# Step 5: Astra Sthapna (THE ULTIMATE FIX)
echo -n "⚡ Astra ko Brahmastra (command) ka roop diya ja raha hai..."
# Create a universal launcher script WITH THE CORRECT LINE BREAKS
LAUNCHER_CONTENT="#!/bin/bash\n$PYTHON_PATH \"$INSTALL_DIR/$MAIN_SCRIPT\""

# Use 'echo -e' which correctly interprets newline characters (\n)
if [[ "$OS_TYPE" == "GNU/Linux" ]]; then
    (echo -e "$LAUNCHER_CONTENT" | sudo tee "$DEST_BIN_PATH" > /dev/null && sudo chmod +x "$DEST_BIN_PATH") &
else
    (echo -e "$LAUNCHER_CONTENT" > "$DEST_BIN_PATH" && chmod +x "$DEST_BIN_PATH") &
fi
# ... (show_progress waisa hi) ...
echo "✅ Safal"

# ... (Antim Gyaan waisa hi)
