#!/bin/bash


source "$(dirname "$0")/../config/config.sh"


function display_usage() {
    echo -e " \e[93mJohn the Ripper is a powerful password cracking tool.\033[0m"
}


function loading_icon() {
    local load_interval="${1}"
    local loading_message="${2}"
    local elapsed=0
    local loading_animation=( '—' "\\" '|' '/' )

    echo -n "${loading_message} "

    tput civis  # Hide the cursor
    trap "tput cnorm" EXIT  # cursor is restored on exit
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.2
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b\n"
}


display_usage


read -p "$(echo -e "\e[96mEnter the path to the wordlist file (or press Enter to use /usr/share/wordlists/rockyou.txt):\033[0m ")" wordlist
if [ -z "$wordlist" ]; then
    wordlist="/usr/share/wordlists/rockyou.txt"
fi


if [ ! -f "$wordlist" ]; then
    echo -e "${COLOR_RED}Error: Wordlist file not found at '$wordlist'.${COLOR_RESET}"
    exit 1
fi


echo -e "\e[95mChoose the hash type you want to crack:\033[0m"
echo -e "\e[35m1) MD5\033[0m"
echo -e "\e[35m2) SHA-1\033[0m"
echo -e "\e[35m3) SHA-256\033[0m"
echo -e "\e[35m4) NTLM\033[0m"
echo -e "\e[35m5) bcrypt\033[0m"
read -p "$(echo -e "\e[96mEnter the number corresponding to the hash type:\033[0m ")" hash_choice


case $hash_choice in
    1)
        format="raw-md5"
        ;;
    2)
        format="raw-sha1"
        ;;
    3)
        format="raw-sha256"
        ;;
    4)
        format="nt"
        ;;
    5)
        format="bcrypt"
        ;;
    *)
        echo -e "${COLOR_RED}Error: Invalid choice.${COLOR_RESET}"
        exit 1
        ;;
esac


read -p "$(echo -e "\e[96mEnter the hash to crack with John the Ripper:\033[0m ")" hash
if [ -z "$hash" ]; then
    echo -e "${COLOR_RED}Error: No hash provided.${COLOR_RESET}"
    exit 1
fi


if ! command -v john &> /dev/null; then
    echo -e "${COLOR_RED}Error: John the Ripper is not installed.${COLOR_RESET}"
    echo "Please install John the Ripper before running this script."
    exit 1
fi


loading_icon 3 "Running John the Ripper..."


temp_file=$(mktemp)
echo "$hash" > "$temp_file"


john --format="$format" --wordlist="$wordlist" "$temp_file"


echo -e "${COLOR_GREEN}Checking cracked passwords...${COLOR_RESET}"
cracked_passwords=$(john --show "$temp_file")


rm "$temp_file"


if [[ "$cracked_passwords" == *"$hash"* ]]; then
    echo -e "${COLOR_CYAN}Cracked Passwords:${COLOR_RESET}"
    echo "$cracked_passwords"
else
    echo -e "${COLOR_RED}No passwords were cracked.${COLOR_RESET}"
fi


echo -e "${COLOR_GREEN}John the Ripper has completed its run.${COLOR_RESET}"


echo -e "${COLOR_RESET}"

