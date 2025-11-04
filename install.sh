#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# 🔥 PROJECT ATMA-NIRBHAR - The Triveni Installer v2.0 🔥
# Ek sampoorn shastragar ki sthapna, ek aadesh mein.
#
# By The Emperor (Sachin Solunke) & his Senapati, Jarvis. ❤️
# ==============================================================================

# --- CONFIGURATION ---
REPO_OWNER="SachinSolunke"
REPO_NAME="Gsm_" # Aapke GitHub repo ka naam
MAIN_SCRIPT="main.py"
INSTALL_NAME="gsm"

PREFIX="/data/data/com.termux/files/usr"
DEST_BIN_PATH="$PREFIX/bin/$INSTALL_NAME"
# Hum ab ek alag, saaf-suthri jagah banayenge
INSTALL_DIR="$PREFIX/opt/$INSTALL_NAME"
DEST_DATA_PATH="$INSTALL_DIR/data"

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
(
    pkg update -y > /dev/null 2>&1
    pkg install python git -y > /dev/null 2>&1
    pip install rich pandas requests > /dev/null 2>&1
) &
show_progress $!
echo "✅ Safal"

# Step 2: Shastragar aur Tarkash ka Nirman
echo -n "📁 Shastragar ($INSTALL_NAME) aur Tarkash (data folder) ka nirman..."
mkdir -p "$DEST_DATA_PATH" &
show_progress $!
echo "✅ Safal"

# Step 3: Dhanush ka Aahvaan (Downloading main script)
echo -n "🐍 Dhanush (Main Script) ka aahvaan kiya ja raha hai..."
MAIN_SCRIPT_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/$MAIN_SCRIPT"
# Hum is baar script ko seedhe uske install directory mein rakhenge
MAIN_SCRIPT_DEST="$INSTALL_DIR/$MAIN_SCRIPT"
(
    curl -sL "$MAIN_SCRIPT_URL" -o "$MAIN_SCRIPT_DEST"
) &
show_progress $!
echo "✅ Safal"

# Step 4: Astra ko chalaane ka raasta banana
echo -n "⚡ Astra ko Brahmastra (command) ka roop diya ja raha hai..."
# Yeh ek choti script banayega jo asli script ko chalayegi
echo "#!/bin/bash" > "$DEST_BIN_PATH"
echo "python \"$MAIN_SCRIPT_DEST\"" >> "$DEST_BIN_PATH"
chmod +x "$DEST_BIN_PATH" &
show_progress $!
echo "✅ Safal"

# Step 5: Antim Gyaan (The First Run Guru)
echo ""
echo "======================================================"
echo "✅ VIJAY! Astra '$INSTALL_NAME' sampoorn roop se taiyar hai."
echo "======================================================"
echo ""
echo "--- GYAAN PEETH ---"
echo "Ise istemal karne ke liye, terminal band karke dobara kholen aur kahin se bhi yeh command likhein:"
echo ""
echo "   $INSTALL_NAME"
echo ""
echo "--- SHAKTIYON KA ISTEMAL ---"
echo "1. Sthaaniya Shakti (Offline):"
echo "   Apni .txt files ko is folder mein rakhein:"
echo "   '$DEST_DATA_PATH'"
echo ""
echo "2. Akashiya Shakti (Online):"
echo "   Astra shuru hone par, 'Live from GitHub' ka option chunein. Yeh aapke"
echo "   GitHub repository '$REPO_NAME/data' se hamesha updated files layega."
echo ""
echo "Aage badhein, Samraat! Aapka astra aapke aadesh ka intezaar kar raha hai."
echo ""
