#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# DARK SYNDICATE OS v2.5 - BANNER STUDIO
# Theme Created By DarkSyndicate Team
# ==========================================================
set -e

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ]; then
    echo "Run this installer inside Termux."
    exit 1
fi

DS="$HOME/.dsos"
mkdir -p "$DS" "$HOME/.config/fish" "$HOME/.termux"

[ -s "$DS/user" ] || printf 'User\n' > "$DS/user"
[ -s "$DS/shellname" ] || printf 'Root\n' > "$DS/shellname"
[ -s "$DS/title" ] || printf 'RAVEN\n' > "$DS/title"
[ -s "$DS/theme" ] || printf 'ocean\n' > "$DS/theme"
[ -s "$DS/symbol" ] || printf '❯\n' > "$DS/symbol"
[ -s "$DS/count" ] || printf '0\n' > "$DS/count"
[ -s "$DS/banner_style" ] || printf 'standard\n' > "$DS/banner_style"

printf '\033[1;36m╔════════════════════════════════════════════╗\n'
printf '║       DARK SYNDICATE OS v2.5 INSTALLER     ║\n'
printf '╚════════════════════════════════════════════╝\033[0m\n'
echo "Each team member can personalize their own banner."
echo

read -rp "Welcome username [$(cat "$DS/user")]: " value
if [ -n "$value" ]; then
    value="$(printf '%s' "$value" | tr -cd 'A-Za-z0-9_-')"
    [ -n "$value" ] && printf '%s\n' "$value" > "$DS/user"
fi

read -rp "Prompt / shell label [$(cat "$DS/shellname")]: " value
if [ -n "$value" ]; then
    value="$(printf '%s' "$value" | tr -cd 'A-Za-z0-9_-')"
    [ -n "$value" ] && printf '%s\n' "$value" > "$DS/shellname"
fi

read -rp "BIG ASCII banner name [$(cat "$DS/title")]: " value
if [ -n "$value" ]; then
    value="$(printf '%s' "$value" | tr -cd 'A-Za-z0-9_-')"
    [ -n "$value" ] && printf '%s\n' "$value" > "$DS/title"
fi

echo
echo "Theme: 1) Ocean  2) Purple  3) Red  4) Green  5) Amber"
read -rp "Choose theme [current: $(cat "$DS/theme")]: " choice
case "$choice" in
    1) echo ocean > "$DS/theme" ;;
    2) echo purple > "$DS/theme" ;;
    3) echo red > "$DS/theme" ;;
    4) echo green > "$DS/theme" ;;
    5) echo amber > "$DS/theme" ;;
esac

echo
echo "[+] Installing Fish shell and FIGlet..."
pkg update -y
pkg install -y fish figlet

FISH_CONFIG="$HOME/.config/fish/config.fish"
touch "$FISH_CONFIG"
sed -i \
    -e '/# DARK_SYNDICATE_V21_START/,/# DARK_SYNDICATE_V21_END/d' \
    -e '/# DARK_SYNDICATE_V22_START/,/# DARK_SYNDICATE_V22_END/d' \
    -e '/# DARK_SYNDICATE_V23_START/,/# DARK_SYNDICATE_V23_END/d' \
    -e '/# DARK_SYNDICATE_V25_START/,/# DARK_SYNDICATE_V25_END/d' \
    "$FISH_CONFIG"

cat >> "$FISH_CONFIG" <<'FISHCONF'

# DARK_SYNDICATE_V25_START
# Dark Syndicate OS v2.5 - Banner Studio
set -g fish_greeting ""
set -g ds_home "$HOME/.dsos"
set -g ds_user (string trim (cat "$ds_home/user" 2>/dev/null))
set -g ds_shell (string trim (cat "$ds_home/shellname" 2>/dev/null))
set -g ds_title (string trim (cat "$ds_home/title" 2>/dev/null))
set -g ds_theme (string trim (cat "$ds_home/theme" 2>/dev/null))
set -g ds_symbol (string trim (cat "$ds_home/symbol" 2>/dev/null))
set -g ds_banner_style (string trim (cat "$ds_home/banner_style" 2>/dev/null))
test -n "$ds_user"; or set -g ds_user User
test -n "$ds_shell"; or set -g ds_shell Root
test -n "$ds_title"; or set -g ds_title RAVEN
test -n "$ds_theme"; or set -g ds_theme ocean
test -n "$ds_symbol"; or set -g ds_symbol '❯'
test -n "$ds_banner_style"; or set -g ds_banner_style standard
test -f "$ds_home/count"; or echo 0 > "$ds_home/count"

function ds_color
    switch $ds_theme
        case ocean; set_color cyan
        case purple; set_color brmagenta
        case red; set_color brred
        case green; set_color brgreen
        case amber; set_color yellow
        case '*'; set_color cyan
    end
end

function ds_banner
    command clear
    ds_color
    printf '╔════════════════════════════════════════════╗\n'
    printf '║                 D A R K  O S                ║\n'
    printf '╚════════════════════════════════════════════╝\n'
    set_color normal
    printf '\n  Welcome back, '
    set_color brwhite
    printf '%s\n\n' "$ds_user"
    ds_color
    if type -q figlet
        figlet -f "$ds_banner_style" "$ds_title" 2>/dev/null; or figlet -f standard "$ds_title" 2>/dev/null
    else
        printf '  %s\n' "$ds_title"
    end
    printf '\n'
    ds_color
    printf '  Theme: %s  |  Type ds-help for commands\n' "$ds_theme"
    printf '  ──────────────────────────────────────────\n'
    set_color brwhite
    printf '       Created By DarkSyndicate Team\n\n'
    set_color normal
end

function clear
    set -l count (string trim (cat "$ds_home/count" 2>/dev/null))
    if not string match -rq '^[0-9]+$' -- "$count"
        set count 0
    end
    set count (math "$count + 1")
    echo $count > "$ds_home/count"
    ds_banner
    ds_color
    printf '  [ CLEAR COUNT: %s ]\n\n' "$count"
    set_color normal
end

function fish_prompt
    ds_color
    printf '%s@%s ' "$ds_user" "$ds_shell"
    set_color brwhite
    printf '%s' (prompt_pwd)
    ds_color
    printf ' %s ' "$ds_symbol"
    set_color normal
end

function ds
    ds_banner
    ds_color
    printf '  [ CLEAR COUNT: %s ]\n\n' (string trim (cat "$ds_home/count"))
    set_color normal
end

function ds-help
    ds_color
    printf '       DARK SYNDICATE COMMAND CENTER\n'
    set_color normal
    printf '  ds          Show dashboard\n'
    printf '  ds-help     Show command list\n'
    printf '  ds-info     Show settings and device info\n'
    printf '  ds-count    Show clear counter\n'
    printf '  ds-user     Change welcome username\n'
    printf '  ds-title    Change BIG ASCII banner name\n'
    printf '  ds-banner   Choose banner design/font\n'
    printf '  ds-shell    Change prompt label\n'
    printf '  ds-symbol   Change prompt symbol\n'
    printf '  ds-theme    Change terminal theme\n'
    printf '  ds-banner   Change banner design (default: classic)\n'
    printf '  ds-reset    Reset clear counter\n'
end

function ds-user
    read -P 'New welcome username: ' value
    set value (string replace -ar '[^A-Za-z0-9_-]' '' -- "$value")
    if test -n "$value"
        echo "$value" > "$ds_home/user"
        set -g ds_user "$value"
        printf 'Welcome username updated.\n'
    else
        printf 'Invalid name.\n'
    end
end

function ds-title
    read -P 'New BIG ASCII banner name: ' value
    set value (string replace -ar '[^A-Za-z0-9_-]' '' -- "$value")
    if test -n "$value"
        echo "$value" > "$ds_home/title"
        set -g ds_title "$value"
        printf 'Big banner name updated to %s\n' "$ds_title"
        ds
    else
        printf 'Invalid name. Use letters, numbers, _ or -.\n'
    end
end

function ds-banner
    printf '\n'
    ds_color
    printf '       BANNER DESIGN STUDIO\n'
    set_color normal
    printf '  Current design: %s\n\n' "$ds_banner_style"
    printf '  1) Classic   - original default look\n'
    printf '  2) Big       - bold, wide lettering\n'
    printf '  3) Slant     - angled lettering\n'
    printf '  4) Small     - compact lettering\n'
    printf '  5) Block     - pixel/block style\n'
    printf '  6) Digital   - segmented tech style\n'
    printf '  7) Banner    - wide terminal banner\n'
    read -P 'Choose design (1-7): ' choice
    switch $choice
        case 1; set choice standard
        case 2; set choice big
        case 3; set choice slant
        case 4; set choice small
        case 5; set choice block
        case 6; set choice digital
        case 7; set choice banner
        case '*'; printf 'Invalid choice. Keeping current design.\n'; return
    end
    if figlet -f "$choice" DSOS_FONT_TEST >/dev/null 2>&1
        echo "$choice" > "$ds_home/banner_style"
        set -g ds_banner_style "$choice"
        printf 'Banner design saved: %s\n' "$choice"
        ds
    else
        printf 'That font is not installed. Keeping current design.\n'
    end
end

function ds-shell
    read -P 'New prompt label: ' value
    set value (string replace -ar '[^A-Za-z0-9_-]' '' -- "$value")
    if test -n "$value"
        echo "$value" > "$ds_home/shellname"
        set -g ds_shell "$value"
        printf 'Prompt label updated.\n'
    else
        printf 'Invalid name.\n'
    end
end

function ds-symbol
    printf '\n1) ❯   2) ➜   3) ➤   4) »\n'
    printf '5) λ   6) >    7) $    8) #\n'
    printf '9) ❱  10) ⌁   11) ⚡\n'
    read -P 'Choose number or type a custom symbol: ' value
    switch $value
        case 1; set value '❯'
        case 2; set value '➜'
        case 3; set value '➤'
        case 4; set value '»'
        case 5; set value 'λ'
        case 6; set value '>'
        case 7; set value '$'
        case 8; set value '#'
        case 9; set value '❱'
        case 10; set value '⌁'
        case 11; set value '⚡'
    end
    if test -n "$value"
        echo "$value" > "$ds_home/symbol"
        set -g ds_symbol "$value"
        printf 'Prompt symbol updated.\n'
    end
end

function ds-theme
    printf '1) Ocean cyan\n2) Purple\n3) Red\n4) Green\n5) Amber\n'
    read -P 'Choose theme: ' choice
    switch $choice
        case 1; set choice ocean
        case 2; set choice purple
        case 3; set choice red
        case 4; set choice green
        case 5; set choice amber
        case '*'; printf 'Invalid choice.\n'; return
    end
    echo "$choice" > "$ds_home/theme"
    set -g ds_theme "$choice"
    ds
end

function ds-count
    printf 'Total clear count: '
    cat "$ds_home/count"
end

function ds-reset
    echo 0 > "$ds_home/count"
    printf 'Clear counter reset.\n'
end

function ds-info
    printf 'Welcome username: %s\n' "$ds_user"
    printf 'Big banner name : %s\n' "$ds_title"
    printf 'Prompt label    : %s\n' "$ds_shell"
    printf 'Prompt symbol   : %s\n' "$ds_symbol"
    printf 'Theme           : %s\n' "$ds_theme"
    printf 'Android         : '
    command getprop ro.build.version.release 2>/dev/null
    printf 'Kernel          : '
    uname -sr
end

set -g fish_color_autosuggestion 555 brblack
set -g fish_color_command cyan
set -g fish_color_error brred

ds_banner
# DARK_SYNDICATE_V25_END
FISHCONF

touch "$HOME/.bashrc"
sed -i '/# DARK_SYNDICATE_LAUNCH_FISH_START/,/# DARK_SYNDICATE_LAUNCH_FISH_END/d' "$HOME/.bashrc"
cat >> "$HOME/.bashrc" <<'BASHLAUNCH'

# DARK_SYNDICATE_LAUNCH_FISH_START
if [ -t 0 ] && [ -z "${DSOS_FISH_STARTED:-}" ] && command -v fish >/dev/null 2>&1; then
    export DSOS_FISH_STARTED=1
    exec fish
fi
# DARK_SYNDICATE_LAUNCH_FISH_END
BASHLAUNCH

PROP="$HOME/.termux/termux.properties"
touch "$PROP"
sed -i '/# DARK_SYNDICATE_V24_KEYS/,+1d' "$PROP"
cat >> "$PROP" <<'KEYS'

# DARK_SYNDICATE_V24_KEYS
extra-keys = [['ESC','TAB','CTRL','ALT'],[{key: UP, display: "⇑"},{key: DOWN, display: "⇓"},{key: LEFT, display: "⇐"},{key: RIGHT, display: "⇒"}],['HOME','END','PGUP','PGDN','-','/','_','~']]
KEYS

echo
printf '\033[1;32m[+] DARK SYNDICATE OS v2.5 installed successfully!\033[0m\n'
echo "Restart Termux to load the personalized dashboard."
echo "Change your large ASCII name later with: ds-title\nChange banner design later with: ds-banner"
echo "Other commands: ds-user | ds-shell | ds-symbol | ds-theme | ds-help"
echo "Theme Created By DarkSyndicate Team"
