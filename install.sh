#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# 🔥 PROJECT ATMA-NIRBHAR - Installer v2.1 (The "Sarva-Adhikaar" Edition) 🔥
# Har permission ki deewar ko todne ke liye.
#
# By The Emperor (Sachin Solunke) & his Senapati, Jarvis. ❤️
# ==============================================================================

# --- CONFIGURATION ---
REPO_OWNER="SachinSolunke"
REPO_NAME="Gsm_"
MAIN_SCRIPT="main.py"
INSTALL_NAME="Gsm"

PREFIX="/data/data/com.termux/files/usr"
DEST_BIN_PATH="$PREFIX/bin/$INSTALL_NAME"
INSTALL_DIR="$PREFIX/opt/$INSTALL_NAME"
DEST_DATA_PATH="$INSTALL_DIR/data"
MAIN_SCRIPT_DEST="$INSTALL_DIR/$MAIN_SCRIPT"
MAIN_SCRIPT_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/$MAIN_SCRIPT"

# --- FUNCTIONS ---
show_progress() {
    local pid=$1; local delay=0.1; local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}; printf " [%c]  " "$spinstr"; local spinstr=$temp${spinstr%"$temp"}; sleep $delay; printf "\b\b\b\b\b\b";
    done
    printf "    \b\b\b\b"
}

# --- MAIN SCRIPT ---
clear
echo "======================================================"
echo "🔱 PROJECT TRIVENI - Sthapna Shuru Ho Rahi Hai... 🔱"
echo "======================================================"

# Step 1: Zaroori Auzaar
echo -n "✨ Zaroori auzaar taiyar kiye ja rahe hain..."
(pkg update -y > /dev/null 2>&1 && pkg install python git -y > /dev/null 2>&1 && pip install rich pandas requests > /dev/null 2>&1) &
show_progress $!
echo "✅ Safal"

# Step 2: Shastragar aur Tarkash ka Nirman
echo -n "📁 Shastragar aur Tarkash ka nirman..."
mkdir -p "$DEST_DATA_PATH" &
show_progress $!
echo "✅ Safal"

# Step 3: Baanon ka Aahvaan (Downloading .txt files)
echo "🏹 Baanon (Market Files) ka aahvaan kiya ja raha hai..."
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$DATA_FOLDER"
files=$(curl -s $API_URL | grep -o 'download_url": "[^"]*' | grep -o '[^"]*$' | grep '.txt$')
if [ -n "$files" ]; then
    for url in $files; do
        filename=$(basename "$url")
        echo -n "   -> $filename ko Tarkash mein rakha ja raha hai..."
        (curl -sL "$url" -o "$DEST_DATA_PATH/$filename") &
        show_progress $!
        echo "✅ Safal"
    done
fi

# Step 4: Dhanush ka Aahvaan (Downloading main script)
echo -n "🐍 Dhanush (Main Script) ka aahvaan..."
(curl -sL "$MAIN_SCRIPT_URL" -o "$MAIN_SCRIPT_DEST") &
show_progress $!
echo "✅ Safal"

# Step 5: Astra Sthapna (THE FIX IS HERE)
echo -n "⚡ Astra ko Brahmastra (command) ka roop diya ja raha hai..."
# Using 'tee' which is more robust with root permissions
(printf "#!/bin/bash\npython \"$MAIN_SCRIPT_DEST\"\n" | tee "$DEST_BIN_PATH" > /dev/null) &
show_progress $!
(chmod +x "$DEST_BIN_PATH") &
show_progress $!
echo "✅ Safal"

echo ""
echo "======================================================"
echo "✅ VIJAY! Astra '$INSTALL_NAME' sampoorn roop se taiyar hai."
echo "======================================================"
# ... (Baaki ka gyaan waisa hi)
