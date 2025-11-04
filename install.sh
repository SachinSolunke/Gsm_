#!/bin/bash
# ==============================================================================
# 🔥 PROJECT SARVA-VYAPI - The Omnipresent Installer v1.0 🔥
# Ek astra, har maidaan ke liye.
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
    # This is a simple spinner for visual feedback
    local pid=$1; local delay=0.1; local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}; printf " [%c]  " "$spinstr"; local spinstr=$temp${spinstr%"$temp"}; sleep $delay; printf "\b\b\b\b\b\b";
    done
    printf "    \b\b\b\b"
}

# --- DIVYA-DRISHTI (ENVIRONMENT DETECTION) ---
clear
echo "======================================================"
echo "🔱 Sarva-Vyapi Astra Sthapna Shuru Ho Rahi Hai... 🔱"
echo "======================================================"

OS_TYPE=$(uname -o)
INSTALL_DIR="" # Will be set based on OS

if [[ "$OS_TYPE" == "Android" ]]; then
    # Maidaan hai Termux
    echo "🔍 Maidaan ki pehchaan hui: Termux (Android)"
    PREFIX="/data/data/com.termux/files/usr"
    INSTALL_DIR="$PREFIX/opt/$INSTALL_NAME"
    DEST_BIN_PATH="$PREFIX/bin/$INSTALL_NAME"
    
    echo -n "✨ Zaroori auzaar (pkg) taiyar kiye ja rahe hain..."
    (pkg update -y > /dev/null 2>&1 && pkg install python git -y > /dev/null 2>&1) &
    show_progress $!
    echo "✅ Safal"

elif [[ "$OS_TYPE" == "GNU/Linux" ]]; then
    # Maidaan hai Kali/Ubuntu/Debian
    echo "🔍 Maidaan ki pehchaan hui: GNU/Linux (Kali/Ubuntu/etc.)"
    # We will install it in a standard Linux location
    INSTALL_DIR="/opt/$INSTALL_NAME"
    DEST_BIN_PATH="/usr/local/bin/$INSTALL_NAME"
    
    echo "🔑 Sudo adhikaar ki zaroorat padegi..."
    echo -n "✨ Zaroori auzaar (apt-get) taiyar kiye ja rahe hain..."
    (sudo apt-get update > /dev/null 2>&1 && sudo apt-get install python3 git python3-pip -y > /dev/null 2>&1) &
    show_progress $!
    echo "✅ Safal"
else
    echo "❌ Galti: Yeh maidaan '$OS_TYPE' anjaan hai. Sthapna radd ki ja rahi hai."
    exit 1
fi

# Universal Python dependencies
echo -n "🐍 Python ki shaktiyan (libraries) sthapit ki ja rahi hain..."
(pip3 install rich requests pandas > /dev/null 2>&1 || pip install rich requests pandas > /dev/null 2>&1) &
show_progress $!
echo "✅ Safal"

# --- UNIVERSAL INSTALLATION STEPS ---

# Step 2: Shastragar aur Tarkash ka Nirman
echo -n "📁 Shastragar aur Tarkash ka nirman..."
(sudo mkdir -p "$INSTALL_DIR/data" && sudo chown -R $(whoami) "$INSTALL_DIR") &> /dev/null &
show_progress $!
echo "✅ Safal"

# Step 3: Baanon ka Aahvaan (Downloading .txt files)
echo "🏹 Baanon (Market Files) ka aahvaan kiya ja raha hai..."
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/data"
files=$(curl -s $API_URL | grep -o 'download_url": "[^"]*' | grep -o '[^"]*$' | grep '.txt$')
if [ -n "$files" ]; then
    for url in $files; do
        filename=$(basename "$url")
        echo -n "   -> $filename ko Tarkash mein rakha ja raha hai..."
        (curl -sL "$url" -o "$INSTALL_DIR/data/$filename") &
        show_progress $!
        echo "✅ Safal"
    done
fi

# Step 4: Dhanush ka Aahvaan (Downloading main script)
echo -n "🐍 Dhanush (Main Script) ka aahvaan..."
MAIN_SCRIPT_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/$MAIN_SCRIPT"
(curl -sL "$MAIN_SCRIPT_URL" -o "$INSTALL_DIR/$MAIN_SCRIPT") &
show_progress $!
echo "✅ Safal"

# Step 5: Astra Sthapna
echo -n "⚡ Astra ko Brahmastra (command) ka roop diya ja raha hai..."
# Create a universal launcher script
LAUNCHER_CONTENT="#!/bin/bash\npython3 \"$INSTALL_DIR/$MAIN_SCRIPT\"\n"
# Use tee with sudo for Linux, direct for Termux
if [[ "$OS_TYPE" == "GNU/Linux" ]]; then
    (printf "%s" "$LAUNCHER_CONTENT" | sudo tee "$DEST_BIN_PATH" > /dev/null && sudo chmod +x "$DEST_BIN_PATH") &
else
    (printf "%s" "$LAUNCHER_CONTENT" > "$DEST_BIN_PATH" && chmod +x "$DEST_BIN_PATH") &
fi
show_progress $!
echo "✅ Safal"

# Step 6: Antim Gyaan
echo ""
echo "======================================================"
echo "✅ VIJAY! Astra '$INSTALL_NAME' sampoorn roop se taiyar hai."
echo "======================================================"
echo ""
echo "Ise istemal karne ke liye, (agar zaroori ho to terminal band karke dobara kholen) aur kahin se bhi yeh command likhein:"
echo ""
echo "   $INSTALL_NAME"
echo ""
