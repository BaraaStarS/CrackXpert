#!/bin/bash



echo                                                                                                         "
" 
                                                                                                              
echo -e "  █████████                               █████      █████ █████                               █████   "
echo -e "  ███░░░░░███                             ░░███      ░░███ ░░███                               ░░███    "
echo -e " ███     ░░░  ████████   ██████    ██████  ░███ █████ ░░███ ███   ████████   ██████  ████████  ███████  "
echo -e "░███         ░░███░░███ ░░░░░███  ███░░███ ░███░░███   ░░█████   ░░███░░███ ███░░███░░███░░███░░░███░   "
echo -e "░███          ░███ ░░░   ███████ ░███ ░░░  ░██████░     ███░███   ░███ ░███░███████  ░███ ░░░   ░███    "
echo -e "░░███     ███ ░███      ███░░███ ░███  ███ ░███░░███   ███ ░░███  ░███ ░███░███░░░   ░███       ░███ ███"
echo -e " ░░█████████  █████    ░░████████░░██████  ████ █████ █████ █████ ░███████ ░░██████  █████      ░░█████ "
echo -e "  ░░░░░░░░░  ░░░░░      ░░░░░░░░  ░░░░░░  ░░░░ ░░░░░ ░░░░░ ░░░░░  ░███░░░   ░░░░░░  ░░░░░        ░░░░░  "
echo -e "                                                                  ░███                                  "
echo -e "                                                                  █████                                 "
echo -e "                                                                  ░░░░░                           "
echo  -e "                                                                        \e[1;35mAutomated Password Cracking Suite\e[0m       "
echo -e "                                                                                 \e[1;35mBara'a Mohammad\e[0m                     "
echo "                                                "
echo "                                                "


function loading_icon() {
    local load_interval="${1}"
    local loading_message="${2}"
    local elapsed=0
    local loading_animation=( '—' "\\" '|' '/' )

    echo -n "${loading_message} "

    
    tput civis
    trap "tput cnorm" EXIT
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.2
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b\n"
}

loading_icon 2 "I'm loading......"



colors1=(
    "\033[0;31m" # Red
    "\033[0;32m" # Green
    "\033[0;33m" # Yellow
    "\033[0;34m" # Blue
    "\033[0;35m" # Magenta
    "\033[0;36m" # Cyan
    "\033[0;37m" # White
)

colors2=(
    "\033[0;37m" # White
    "\033[0;36m" # Cyan
    "\033[0;35m" # Magenta
    "\033[0;34m" # Blue
    "\033[0;33m" # Yellow
    "\033[0;32m" # Green
    "\033[0;31m" # Red
)

pattern1='/\\'
pattern2='\/'

num_groups=10
output1=""
output2=""

for ((i = 0; i < num_groups; i++)); do
    color="${colors1[$((i % ${#colors1[@]}))]}"
    output1+="${color}${pattern1} "
done

for ((i = 0; i < num_groups; i++)); do
    color="${colors2[$((i % ${#colors2[@]}))]}"
    output2+="${color}${pattern2} "
done

reset="\033[0m"
echo -e "${output1}${reset}"
echo -e "${output2}${reset}"





echo -e "\n "

source "$(dirname "$0")/config/config.sh"

COLOR_MAGENTA="\033[1;35m"
COLOR_RESET="\033[0m"
COLOR_GRAY="\033[1;30m"

WORDLIST=""
IDENTIFY=false
JOHN=false
HASHCAT=false
HYDRA=false


  

echo -e "\033[0;36mChoose an option:\033[0m"
echo -e "${COLOR_CYAN}1) Guess the password and suggest a wordlist${COLOR_RESET}"
echo -e "${COLOR_CYAN}2) Identify hash type${COLOR_RESET}"
echo -e "${COLOR_CYAN}3) Word to hash${COLOR_RESET}"
echo -e "${COLOR_CYAN}4) Password Strength Estimator${COLOR_RESET}"
echo -e "${COLOR_CYAN}5) Run John the Ripper${COLOR_RESET}"
echo -e "${COLOR_CYAN}6) Run Hashcat${COLOR_RESET}"
echo -e "${COLOR_CYAN}7) Run Hydra${COLOR_RESET}"
echo -e "${COLOR_RED}8) Exit${COLOR_RESET}"


read -p "$(echo -e "\e[92mEnter your choice:\e[0m ")" choice



case $choice in
  1)

    bash "$(dirname "$0")/lib/wordlist_generator.sh" "$target_info"
    ;;
  2)
    read -p "$(echo -e "\e[94mEnter the hash to identify:\033[0m ")" hash
    bash "$(dirname "$0")/lib/hash_identifier.sh" "$hash"
    ;;
  3)

    bash "$(dirname "$0")/lib/cal+_hash.sh" "$word"
    ;;
  4)

    bash "$(dirname "$0")/lib/pass_strong.sh" "$hash"
    ;;
  5)

    bash "$(dirname "$0")/lib/john.sh" "$hash"
    ;;
  6)
    
    bash "$(dirname "$0")/lib/hashcat.sh" "$hash"
    ;;
  7)
    read -p "Enter the target and protocol for Hydra: " target protocol
    bash "$(dirname "$0")/lib/hydra.sh" "$target" "$protocol"
    ;;
  8)
    echo "Exiting..."
    echo "Goodbye!"
    exit 0
    ;;
  *)
    echo "Invalid choice, please try again."
    usage
    ;;
esac




  
