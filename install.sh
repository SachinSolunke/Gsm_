#!/bin/bash
# ==============================================================================
# 🔥 PROJECT SARVA-VYAPI - The "Sampoorn-Astra" Installer v2.0 🔥
# Ek astra jise apna raasta hamesha pata hota hai.
#
# By The Emperor (Sachin Solunke) & his Senapati, Jarvis. ❤️
# ==============================================================================

# --- CONFIGURATION ---
REPO_OWNER="SachinSolunke"
REPO_NAME="Gsm_"
MAIN_SCRIPT="main.py"
INSTALL_NAME="gsm"

# --- FUNCTIONS ---
show_progress() {
    # ... (Same as before)
    local pid=$1; while ps -p $pid > /dev/null; do printf "."; sleep 0.5; done
}

# --- DIVYA-DRISHTI (ENVIRONMENT DETECTION) ---
clear
echo "======================================================"
echo "🔱 Sarva-Vyapi Astra Sthapna Shuru Ho Rahi Hai... 🔱"
echo "======================================================"

OS_TYPE=$(uname -o)
INSTALL_DIR=""
PYTHON_PATH="" # Yahan hum Python ka asli address store karenge

if [[ "$OS_TYPE" == "Android" ]]; then
    # Maidaan hai Termux
    echo "🔍 Maidaan ki pehchaan hui: Termux"
    PREFIX="/data/data/com.termux/files/usr"
    INSTALL_DIR="$PREFIX/opt/$INSTALL_NAME"
    DEST_BIN_PATH="$PREFIX/bin/$INSTALL_NAME"
    echo -n "✨ Zaroori auzaar (pkg) taiyar kiye ja rahe hain..."
    (pkg update -y >/dev/null 2>&1 && pkg install python git -y >/dev/null 2>&1) &
    show_progress $!
    echo "✅"
    PYTHON_PATH=$(command -v python)

elif [[ "$OS_TYPE" == "GNU/Linux" ]]; then
    # Maidaan hai Kali/Ubuntu/Debian
    echo "🔍 Maidaan ki pehchaan hui: GNU/Linux"
    INSTALL_DIR="/opt/$INSTALL_NAME"
    DEST_BIN_PATH="/usr/local/bin/$INSTALL_NAME"
    echo -n "✨ Zaroori auzaar (apt-get) taiyar kiye ja rahe hain..."
    (sudo apt-get update >/dev/null 2>&1 && sudo apt-get install python3 git python3-pip -y >/dev/null 2>&1) &
    show_progress $!
    echo "✅"
    PYTHON_PATH=$(command -v python3)
else
    echo "❌ Galti: Yeh maidaan '$OS_TYPE' anjaan hai."
    exit 1
fi

if [ -z "$PYTHON_PATH" ]; then
    echo "❌ Galti: Python ka sthapna path nahi mil saka. Sthapna radd ki ja rahi hai."
    exit 1
fi
echo "🐍 Python ka raasta mil gaya hai: $PYTHON_PATH"

# ... (Baaki saara installation logic waisa hi)

# Step 5: Astra Sthapna (THE ULTIMATE FIX)
echo -n "⚡ Astra ko Brahmastra (command) ka roop diya ja raha hai..."
# Create a universal launcher script WITH THE FULL PYTHON PATH
LAUNCHER_CONTENT="#!/bin/bash\n$PYTHON_PATH \"$INSTALL_DIR/$MAIN_SCRIPT\"\n"
# Use tee with sudo for Linux, direct for Termux
if [[ "$OS_TYPE" == "GNU/Linux" ]]; then
    (printf "%s" "$LAUNCHER_CONTENT" | sudo tee "$DEST_BIN_PATH" > /dev/null && sudo chmod +x "$DEST_BIN_PATH") &
else
    (printf "%s" "$LAUNCHER_CONTENT" > "$DEST_BIN_PATH" && chmod +x "$DEST_BIN_PATH") &
fi
show_progress $!
echo "✅ Safal"

# ... (Antim Gyaan waisa hi)
