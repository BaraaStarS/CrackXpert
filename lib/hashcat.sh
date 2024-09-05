#!/bin/bash


CONFIG_PATH="$(dirname "$0")/../config/config.sh"
if [ -f "$CONFIG_PATH" ]; then
    source "$CONFIG_PATH"
else

    COLOR_RESET="\e[0m"
    COLOR_RED="\e[31m"
    COLOR_GREEN="\e[32m"
    COLOR_CYAN="\e[36m"
    COLOR_MAGENTA="\e[35m"
fi


function loading_icon() {
    local load_interval="${1}"
    local loading_message="${2}"
    local elapsed=0
    local loading_animation=( '—' "\\" '|' '/' )

    echo -n "${loading_message} "

    tput civis  
    trap "tput cnorm" EXIT  #  cursor is restored on exit
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.2
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b\n"
}


if ! command -v hashcat &> /dev/null; then
    echo -e "${COLOR_RED}Error: Hashcat is not installed.${COLOR_RESET}"
    echo "Please install Hashcat before running this script."
    exit 1
fi


function display_hash_modes() {
    echo -e "${COLOR_CYAN}Available Hash Modes:${COLOR_RESET}"
    echo -e "\e[94m0   | MD5\033[0m "
    echo -e "\e[94m100 | SHA1\033[0m "
    echo -e "\e[94m1400 | SHA-256\033[0m "
    echo -e "\e[94m1700 | SHA-512\033[0m "
    echo -e "\e[94m1800 | bcrypt\033[0m "
    echo -e "\e[94m2500 | WPA/WPA2\033[0m "
    echo -e "\e[94m3200 | bcrypt $2*$6$\033[0m "
    echo -e "\e[94m500 | MD5CRYPT\033[0m "
    echo -e "\e[94m400 | phpass, WordPress\033[0m "
    echo -e "\e[94m16800 | WPA-PMKID-PBKDF2\033[0m "

    echo -e "${COLOR_MAGENTA}Refer to Hashcat documentation for a full list of hash modes.${COLOR_RESET}"
}


echo -e "${COLOR_CYAN}Welcome to the Hashcat Interface!${COLOR_RESET}"


display_hash_modes
read -p "$(echo -e "\e[90mEnter the hash mode number (e.g., 0 for MD5): \033[0m") " hash_mode
if [ -z "$hash_mode" ]; then
    echo -e "${COLOR_RED}Error: No hash mode selected.${COLOR_RESET}"
    exit 1
fi


read -p "$(echo -e "\e[90mEnter the path to the file containing the hash(es): \033[0m") " hash_file
if [ ! -f "$hash_file" ]; then
    echo -e "${COLOR_RED}Error: Hash file not found.${COLOR_RESET}"
    exit 1
fi


read -p "$(echo -e "\e[90mEnter the path to the wordlist file: \033[0m") " wordlist
if [ ! -f "$wordlist" ]; then
    echo -e "${COLOR_RED}Error: Wordlist file not found.${COLOR_RESET}"
    exit 1
fi


read -p "$(echo -e "\e[90mEnter any additional Hashcat options (or press Enter to skip): \033[0m") " additional_options


loading_icon 3 "Running Hashcat..."


hashcat -m "$hash_mode" -a 0 -o cracked.txt "$hash_file" "$wordlist" $additional_options


if [ -f "cracked.txt" ] && [ -s "cracked.txt" ]; then
    echo -e "${COLOR_GREEN}Hashcat has successfully cracked the following passwords:${COLOR_RESET}"
    cat cracked.txt
else
    echo -e "${COLOR_RED}No passwords were cracked.${COLOR_RESET}"
fi


rm -f cracked.txt


echo -e "${COLOR_GREEN}Hashcat has completed its run.${COLOR_RESET}"


echo -e "${COLOR_RESET}"

