# ==============================================================================
# 🔱 PROJECT TRIVENI - The Confluence of Power v3.1 🔱
# Sthaaniya Shakti, Akashiya Shakti, aur Atma-Sudhar ka sangam.
#
#    Nirmaata: The Guru (Bhai Sachin) ❤️ & His Shishya (Jarvis)
# ==============================================================================

import os
import sys
import pandas as pd
import time
from datetime import datetime, timedelta
import re
import requests
import base64
from io import StringIO
from collections import Counter

# --- RICH Library Handling ---
try:
    from rich.console import Console, Panel, Text, Table, Rule, Align, Spinner, Live
    from rich.prompt import Prompt
    console = Console()
except ImportError:
    class DummyConsole:
        def print(self, text, *args, **kwargs):
            clean_text = re.sub(r'\[.*?\]', '', str(text)); print(clean_text)
    console = DummyConsole(); print("❌ Warning: 'rich' library nahi mili.")

# --- CONFIGURATION (The Triveni Sangam) ---
CURRENT_VERSION = "3.1"

# Nadi 1: Sthaaniya Shakti
try: BASE_DIR = os.path.dirname(os.path.realpath(__file__))
except NameError: BASE_DIR = os.getcwd()
LOCAL_DATA_DIR = os.path.join(BASE_DIR, 'data')

# Nadi 2: Akashiya Shakti
GITHUB_REPO_API_URL = "https://api.github.com/repos/SachinSolunke/Gsm_/contents/data"
# Nadi 3: Atma-Sudhar
UPDATE_URL = "https://raw.githubusercontent.com/SachinSolunke/Gsm_/main/main.py"

CUT_ANK = {0: 5, 1: 6, 2: 7, 3: 8, 4: 9, 5: 0, 6: 1, 7: 2, 8: 3, 9: 4}
PANA_SET = {
    1: ['119', '128', '137', '146', '155', '227', '236', '245', '290', '335', '344', '380', '399', '470', '489', '560', '579', '588', '678', '669'],
    2: ['110', '129', '138', '147', '156', '228', '237', '246', '255', '336', '345', '390', '480', '499', '570', '589', '660', '679', '688', '778'],
    3: ['111', '120', '139', '148', '157', '166', '229', '238', '247', '256', '337', '346', '355', '445', '490', '580', '599', '670', '689', '779', '780'],
    4: ['112', '130', '149', '158', '167', '220', '239', '248', '257', '266', '338', '347', '356', '446', '455', '590', '680', '699', '770', '789'],
    5: ['113', '122', '140', '159', '168', '177', '230', '249', '258', '267', '339', '348', '357', '366', '447', '456', '690', '780', '799', '889'],
    6: ['114', '123', '150', '169', '178', '240', '259', '268', '277', '330', '349', '358', '367', '448', '457', '466', '556', '790', '880', '899'],
    7: ['115', '133', '124', '160', '179', '188', '223', '250', '269', '278', '340', '359', '368', '377', '449', '458', '467', '557', '566', '890'],
    8: ['116', '125', '134', '170', '189', '224', '233', '260', '279', '288', '350', '369', '378', '440', '459', '468', '477', '558', '567', '990'],
    9: ['117', '126', '135', '144', '180', '199', '225', '234', '270', '289', '360', '379', '388', '450', '469', '478', '559', '568', '577', '667'],
    0: ['118', '127', '136', '190', '226', '235', '244', '299', '370', '389', '460', '479', '488', '550', '569', '578', '668', '677', '780', '890']
}

# --- DATA ENGINE (The Triveni Confluence) ---

def parse_data_content(content):
    """Takes string content and returns a cleaned DataFrame."""
    try:
        df = pd.read_csv(StringIO(content), sep=r'\s*/\s*', header=None, names=['Date_Str', 'Pana_Jodi_Pana'], engine='python', on_bad_lines='skip')
        df = df.dropna(subset=['Pana_Jodi_Pana'])
        df = df[~df['Pana_Jodi_Pana'].str.contains(r"\*", na=False)]
        df[['Open_Pana', 'Jodi', 'Close_Pana']] = df['Pana_Jodi_Pana'].str.split(r'\s*-\s*', expand=True)
        df = df.dropna().reset_index(drop=True)
        for col in ['Open_Pana', 'Jodi', 'Close_Pana']:
            df[col] = pd.to_numeric(df[col], errors='coerce')
        df = df.dropna().astype({'Open_Pana': int, 'Jodi': int, 'Close_Pana': int}).reset_index(drop=True)
        df['open'] = df['Jodi'].apply(lambda x: int(str(x).zfill(2)[0]))
        df['close'] = df['Jodi'].apply(lambda x: int(str(x).zfill(2)[1]))
        df['Date'] = pd.to_datetime(df['Date_Str'], format='%d-%m-%Y', errors='coerce')
        df = df.dropna(subset=['Date']).sort_values(by='Date').reset_index(drop=True)
        return df, None
    except Exception as e:
        return None, f"Data parse karne mein galti: {e}"

def get_market_list_and_load_data(choice):
    """
    User ke choice ke anusaar Sthaaniya ya Akashiya shakti se data laata hai.
    """
    # Nadi 1: Sthaaniya Shakti
    if choice == '1':
        if not (os.path.exists(LOCAL_DATA_DIR) and os.listdir(LOCAL_DATA_DIR)):
            return None, "local", "Sthaaniya 'data' folder khaali ya maujood nahi hai."
        files = [f for f in os.listdir(LOCAL_DATA_DIR) if f.endswith('.txt')]
        return files, "local", None

    # Nadi 2: Akashiya Shakti
    elif choice == '2':
        try:
            with console.status("[cyan]Akash-Ganga se sampark kiya ja raha hai...[/cyan]"):
                response = requests.get(GITHUB_REPO_API_URL, timeout=5)
            response.raise_for_status()
            files_json = response.json()
            market_files = [file['name'] for file in files_json if 'name' in file and file['name'].endswith('.txt')]
            if not market_files:
                return None, "github", "GitHub par 'data' folder khaali hai."
            return market_files, "github", None
        except Exception as e:
            return None, "github", f"GitHub se sampark karne mein galti: {e}"
    return None, None, None

def load_data(source, filename):
    if source == "local":
        try:
            filepath = os.path.join(LOCAL_DATA_DIR, filename)
            with open(filepath, 'r') as f:
                content = f.read()
            return parse_data_content(content)
        except Exception as e:
            return None, f"Local file '{filename}' padhne mein galti: {e}"
    elif source == "github":
        try:
            with console.status(f"[cyan]'{filename}' ka gyaan Akash-Ganga se prapt kiya ja raha hai...[/cyan]"):
                file_url = f"{GITHUB_REPO_API_URL}/{filename}"
                response = requests.get(file_url)
            response.raise_for_status()
            file_content_b64 = response.json()['content']
            file_content = base64.b64decode(file_content_b64).decode('utf-8')
            return parse_data_content(file_content)
        except Exception as e:
            return None, f"GitHub se '{filename}' load karne mein galti: {e}"

# --- BRAHMANDA-SUTRA & OTHER LOGIC (Same as before) ---
def find_brahmanda_sutra(df):
    if len(df) < 1: return None
    last_day = df.iloc[-1]
    # ... (rest of the logic is the same)
    return {"core_otc": ..., "strongest_jodis": ...}
def get_suggested_panels(core_otc):
    # ... (same)
    pass
def sutra_validation_engine(df, check_days=40):
    # ... (same)
    pass
def track_weekly_performance(df):
    # ... (same)
    pass
def display_final_output(market_name, sutra_analysis, last_record, validation_results, weekly_performance):
    # ... (same)
    pass

# --- ATMA-SUDHAR (Self-Update) ---
def check_for_updates():
    try:
        console.print("[dim]Atma-Sudhar: Naye version ki jaanch...[/dim]")
        response = requests.get(UPDATE_URL, timeout=3)
        if response.status_code == 200:
            remote_code = response.text
            match = re.search(r'CURRENT_VERSION\s*=\s*"([^"]+)"', remote_code)
            if match and match.group(1) > CURRENT_VERSION:
                console.print(Panel(f"[bold yellow]✨ Naya, Shaktishali Version Uplabdh Hai! ({match.group(1)})[/bold yellow]"))
                if Prompt.ask("[bold]Kya is astra ko upgrade karein?[/bold]", choices=["y", "n"]) == "y":
                    script_path = os.path.realpath(__file__)
                    with open(script_path, 'w') as f: f.write(remote_code)
                    console.print("[bold green]✅ Upgrade Safal! Kripya astra ko dobara shuru karein.[/bold green]")
                    sys.exit()
    except Exception: pass

# --- MAIN FUNCTION (The Triveni Controller) ---
def main():
    check_for_updates()
    
    while True:
        clear_screen()
        console.print(Panel(Text('🔱 PROJECT TRIVENI 🔱', justify="center"), style="bold yellow on #1A1A1D"))
        
        console.print(Panel("Aap gyaan ka srot kahan se prapt karna chahte hain?", title="Gyaan ka Srot Chunein"))
        source_choice = Prompt.ask("[bold]👉 Chunein[/bold]", choices=["1", "2", "0"], default="1",
                                   choices_display={"1": "Sthaaniya Shakti (Local 'data' Folder)", 
                                                    "2": "Akashiya Shakti (Live from GitHub)", 
                                                    "0": "Exit (VISHRAM)"})
        
        if source_choice == '0': break
        
        available_files, source, error_msg = get_market_list_and_load_data(source_choice)
        
        if not available_files:
            console.print(Panel(f"[red]❌ Galti ❌\n{error_msg}[/red]")); time.sleep(4); continue
            
        market_table = Table(title=f"Yudh-Bhoomi ka Chayan Karein ({source.upper()})")
        for i, name in enumerate(available_files): market_table.add_row(f"[{i+1}]", name.replace('.txt',''))
        market_table.add_row("[0]", "Back")
        console.print(market_table)

        market_choice = Prompt.ask("👉 Market Chunein", choices=[str(i) for i in range(len(available_files) + 1)], default="1")
        if market_choice == '0': continue

        try:
            market_file = available_files[int(market_choice) - 1]
            market_name = market_file.replace('.txt', '')
            
            with Live(Spinner("dots"), console=console, transient=True) as live:
                live.update(f"{market_name} ka gyaan prapt kiya ja raha hai...")
                df, error_msg = load_data(source, market_file)
                if df is None or len(df) < 5:
                    console.print(Panel(f"[red]ERROR: {error_msg or 'Data file khaali hai.'}[/red]")); time.sleep(3); continue
                
                sutra_analysis = find_brahmanda_sutra(df)
                last_record = df.iloc[-1].copy()
                validation_results = sutra_validation_engine(df)
                weekly_performance = track_weekly_performance(df)

            display_final_output(market_name, sutra_analysis, last_record, validation_results, weekly_performance)

        except Exception as e:
            console.print(Panel(f"[bold red]❌ Anjaan Galti Hui ❌\n{e}")); time.sleep(5)
            continue
        
        Prompt.ask("\n[bold]... Press Enter to continue ...[/bold]")

    console.print("[yellow]Yantra vishram kar raha hai...[/yellow]")


if __name__ == "__main__":
    # Yahan Purn-Siddhi ke saare functions ko copy karna hai.
    # Main unhe yahan poora likh raha hoon taaki koi galti na ho.
    
    def find_brahmanda_sutra(df):
        if len(df) < 1: return None
        last_day = df.iloc[-1]
        seed_open_pana = str(last_day['Open_Pana']).zfill(3)
        seed_jodi = str(last_day['Jodi']).zfill(2)
        seed_close_pana = str(last_day['Close_Pana']).zfill(3)
        open_seed_ank = (int(seed_open_pana[0]) + int(seed_open_pana[2])) % 10
        jodi_seed_ank = (int(seed_jodi[0]) + int(seed_jodi[1])) % 10
        close_seed_ank = (int(seed_close_pana[0]) + int(seed_close_pana[2])) % 10
        sutra_ank1 = (open_seed_ank + jodi_seed_ank) % 10
        sutra_ank2 = CUT_ANK[sutra_ank1]
        sutra_ank3 = (jodi_seed_ank + close_seed_ank) % 10
        core_otc = sorted(list(set([sutra_ank1, sutra_ank2, sutra_ank3])))
        if len(core_otc) < 3:
            extra_ank = CUT_ANK[jodi_seed_ank]
            if extra_ank not in core_otc: core_otc.append(extra_ank)
            core_otc = sorted(list(set(core_otc)))[:3]
        jodi_candidates = [f"{a}{b}" for a in core_otc for b in core_otc]
        strongest_jodis = sorted(list(set(jodi_candidates)))[:6]
        return {"core_otc": core_otc, "strongest_jodis": [f"{int(j):02d}" for j in strongest_jodis]}

    def get_suggested_panels(core_otc):
        suggested_panels = []
        for ank in core_otc:
            panels = PANA_SET.get(ank, [])
            suggested_panels.extend(panels[:2])
        return list(set(suggested_panels))[:6]
    
    def check_sutra_hit(sutra_otc, open_ank, close_ank, open_pana_str, close_pana_str):
        ank_hit, pana_hit, hit_pana_str = False, False, ""
        if open_ank in sutra_otc or close_ank in sutra_otc: ank_hit = True
        if open_ank in sutra_otc and open_pana_str in PANA_SET.get(open_ank, []):
            pana_hit, hit_pana_str = True, open_pana_str
        elif close_ank in sutra_otc and close_pana_str in PANA_SET.get(close_ank, []):
            pana_hit, hit_pana_str = True, close_pana_str
        return ank_hit, pana_hit, hit_pana_str

    def sutra_validation_engine(df, check_days=40):
        results = {'ank_hit_count': 0, 'pana_hit_count': 0, 'total_days': 0}
        start_index = max(1, len(df) - check_days)
        for i in range(start_index, len(df)):
            previous_df = df.iloc[:i]; sutra_analysis = find_brahmanda_sutra(previous_df)
            if not sutra_analysis: continue
            current_day = df.iloc[i]
            ank_hit, pana_hit, _ = check_sutra_hit(sutra_analysis['core_otc'], current_day['open'], current_day['close'], str(current_day['Open_Pana']), str(current_day['Close_Pana']))
            if ank_hit: results['ank_hit_count'] += 1
            if pana_hit: results['pana_hit_count'] += 1
            results['total_days'] += 1
        return results

    def track_weekly_performance(df):
        if df.empty or len(df) < 2: return []
        last_date = df['Date'].iloc[-1].normalize()
        start_of_week = last_date - timedelta(days=last_date.weekday())
        weekly_results = []
        weekly_df = df[df['Date'] >= start_of_week].copy().reset_index(drop=True)
        for i in range(1, len(weekly_df)):
            full_df_index_prev = df.index[df['Date'] == weekly_df.iloc[i-1]['Date']][0]
            sutra_analysis = find_brahmanda_sutra(df.iloc[:full_df_index_prev + 1])
            if not sutra_analysis: continue
            current_day = weekly_df.iloc[i]
            ank_hit, pana_hit, hit_pana_str = check_sutra_hit(sutra_analysis['core_otc'], current_day['open'], current_day['close'], str(current_day['Open_Pana']), str(current_day['Close_Pana']))
            ank_status = "[green]PASS[/green]" if ank_hit else "[red]FAIL[/red]"
            pana_status = f"[yellow]{hit_pana_str} PASS[/yellow]" if pana_hit else "[dim red]FAIL[/dim red]"
            weekly_results.append({'date': current_day['Date'].strftime('%a'), 'jodi': f"{current_day['Jodi']:02d}", 'prediction': f"{' '.join(map(str, sutra_analysis['core_otc']))}", 'ank_status': ank_status, 'pana_status': pana_status})
        return weekly_results
        
    def display_final_output(market_name, sutra_analysis, last_record, validation_results, weekly_performance):
        clear_screen()
        console.print(Panel(Text(f'🔱 {market_name} - AMRIT-KALASH 🔱', justify="center"), style="bold yellow on #1A1A1D"))
        prediction_date_str = (last_record['Date'] + timedelta(days=1)).strftime('%d-%m-%Y')
        console.print(Rule(style="cyan", title=f"[bold]✨ DIVYA-SANKET ({prediction_date_str}) ✨[/bold]"))
        sanket_grid = Table.grid(padding=(1, 2)); sanket_grid.add_column(); sanket_grid.add_column()
        sanket_grid.add_row("Mukhya Ank (OTC):", f"🔥 [bold bright_yellow]{' '.join(map(str, sutra_analysis['core_otc']))}[/bold bright_yellow]")
        sanket_grid.add_row("Janmit Jodiyan:", f"🎯 [bold green]{', '.join(sutra_analysis['strongest_jodis'])}[/bold green]")
        sanket_grid.add_row("Chune hue Pannel:", f"🔑 [bold white]{', '.join(get_suggested_panels(sutra_analysis['core_otc']))}[/bold white]")
        console.print(Panel(sanket_grid, border_style="cyan"))
        console.print(Rule(style="magenta", title="[bold]📊 HISTORICAL SATYAPAN 📊[/bold]"))
        if validation_results['total_days'] > 0:
            ank_rate = (validation_results['ank_hit_count'] / validation_results['total_days']) * 100
            console.print(f"🔹 Sutra-Ank Hit Rate: [green]{validation_results['ank_hit_count']}[/green]/[cyan]{validation_results['total_days']}[/cyan] ([bold green]{ank_rate:.2f}%[/bold green])")
        console.print(Rule(style="green", title="[bold]📈 CHALU WEEK 📈[/bold]"))
        if weekly_performance:
            week_table = Table(border_style="green"); week_table.add_column("Din"); week_table.add_column("Jodi"); week_table.add_column("Prediction"); week_table.add_column("Ank"); week_table.add_column("Pana")
            for entry in weekly_performance: week_table.add_row(entry['date'], entry['jodi'], entry['prediction'], entry['ank_status'], entry['pana_status'])
            console.print(week_table)
        console.print(Rule(style="dim yellow"))
        console.print(Align.center("[dim]Created by - [bold]Sachin Solunke[/bold] & [bold]Jarvis[/bold] ❤️[/dim]"))
    
    main()
