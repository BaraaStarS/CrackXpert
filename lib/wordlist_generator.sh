#!/bin/bash

declare -A profile

get_input() {
    local prompt="$1"
    local key="$2"
    
    while true; do
        read -p "$(echo -e "\e[93m>\033[0m \e[92m$prompt\033[0m ")" input
        if [ -z "$input" ] || [ "$input" == "0" ]; then
            input="n/a"  
            break
        elif [[ "$key" =~ birthdate|wifeb|kidb ]]; then
            if [[ ${#input} -eq 8 ]]; then
                break
            else
                echo -e "\e[31m[-] You must enter 8 digits for the birthdate or '0' if unknown.\033[0m"
            fi
        else
            break
        fi
    done
    
    profile["$key"]="${input,,}"  
}

get_input "First Name:" "name"
while [ "${profile["name"]}" == "n/a" ]; do
    echo -e "\e[31m[-] You must enter a name at least!\033[0m"
    get_input "First Name:" "name"
done

get_input "Surname:" "surname"
get_input "Nickname:" "nick"
get_input "Birthdate (DDMMYYYY) or 0 if unknown:" "birthdate"

get_input "Partner's name or 0 if unknown:" "wife"
get_input "Partner's nickname or 0 if unknown:" "wifen"
get_input "Partner's birthdate (DDMMYYYY) or 0 if unknown:" "wifeb"

get_input "Child's name or 0 if unknown:" "kid"
get_input "Child's nickname or 0 if unknown:" "kidn"
get_input "Child's birthdate (DDMMYYYY) or 0 if unknown:" "kidb"

get_input "Pet's name or 0 if unknown:" "pet"
get_input "Company name or 0 if unknown:" "company"

read -p "$(echo -e "\e[93m>\033[0m \e[92mDo you want to add some keywords about the victim? Y/[N]:\033[0m ")" add_keywords
if [[ "${add_keywords,,}" == "y" ]]; then
    read -p "$(echo -e "\e[93m>\033[0m \e[92mPlease enter the words, separated by commas [i.e., hacker,juice,black], spaces will be removed:\033[0m ")" words
    profile["words"]="${words// /}"
else
    profile["words"]=""
fi

read -p "$(echo -e "\e[93m>\033[0m \e[92mDo you want to add special chars at the end of words? Y/[N]:\033[0m ")" add_spechars
profile["spechars1"]="${add_spechars,,}"

read -p "$(echo -e "\e[93m>\033[0m \e[92mDo you want to add some random numbers at the end of words? Y/[N]:\033[0m ")" add_randnum
profile["randnum"]="${add_randnum,,}"

# Function to generate wordlist
generate_wordlist_from_profile() {
    local wordlist_file="wordlist.txt"
    > "$wordlist_file"

    local words=("${profile["name"]}" "${profile["surname"]}" "${profile["nick"]}" "${profile["wife"]}" "${profile["wifen"]}" "${profile["kid"]}" "${profile["kidn"]}" "${profile["pet"]}" "${profile["company"]}")
    local special_chars=("!" "@" "#" "$" "%" "&" "*")
    local numbers=("123" "2024" "456" "789")

    for word in "${words[@]}"; do
        if [ "$word" != "n/a" ]; then
            echo "$word" >> "$wordlist_file"
            for num in "${numbers[@]}"; do
                echo "${word}${num}" >> "$wordlist_file"
            done
            for char in "${special_chars[@]}"; do
                echo "${word}${char}" >> "$wordlist_file"
            done
        fi
    done

    local birthdates=("${profile["birthdate"]}" "${profile["wifeb"]}" "${profile["kidb"]}")
    for date in "${birthdates[@]}"; do
        if [ "$date" != "n/a" ]; then
            echo "$date" >> "$wordlist_file"
            echo "${date:0:2}" >> "$wordlist_file"   # Day
            echo "${date:2:2}" >> "$wordlist_file"   # Month
            echo "${date:4:4}" >> "$wordlist_file"   # Year
            echo "${date:0:4}" >> "$wordlist_file"   # Year+Month
        fi
    done

    IFS=',' read -ra additional_words <<< "${profile["words"]}"
    for keyword in "${additional_words[@]}"; do
        [ "$keyword" != "" ] && echo "$keyword" >> "$wordlist_file"
    done

    local suggested_passwords=()
    
    if [ "${profile["name"]}" != "n/a" ]; then
        suggested_passwords+=("${profile["name"]}${profile["birthdate"]:0:4}")
    fi

    if [ "${profile["name"]}" != "n/a" ] && [ "${profile["surname"]}" != "n/a" ]; then
        suggested_passwords+=("${profile["name"]}${profile["surname"]}${profile["birthdate"]:4:4}")
    fi

    if [ "${profile["name"]}" != "n/a" ] && [ "${profile["kid"]}" != "n/a" ]; then
        suggested_passwords+=("${profile["name"]}${profile["kid"]}${profile["birthdate"]:0:4}")
    fi

    if [ "${profile["pet"]}" != "n/a" ]; then
        suggested_passwords+=("${profile["pet"]}${profile["birthdate"]:0:4}")
    fi

    if [ "${profile["name"]}" != "n/a" ] && [ "${profile["company"]}" != "n/a" ]; then
        suggested_passwords+=("${profile["name"]}${profile["company"]}${profile["birthdate"]:0:4}")
    fi

    echo -e "\e[92mSuggested Passwords:\033[0m"
    for pass in "${suggested_passwords[@]}"; do
        echo "- $pass"
    done
    
    echo -e "\e[92mWordlist generated: $wordlist_file\033[0m"
}

generate_wordlist_from_profile

