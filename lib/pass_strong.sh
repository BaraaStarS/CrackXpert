#!/bin/bash

echo -e "\e[33mStrong Password Criteria:\033[0m "
echo -e " \e[32m - Length: At least 12-16 characters long.\033[0m"
echo -e " \e[32m - Complexity: Includes uppercase letters, lowercase letters, numbers, and at least 2 special characters.\033[0m"
echo -e " \e[32m - Unpredictability: Avoids simple patterns and easily guessable information.\033[0m"
echo
echo -e "\e[33mModerate Password Criteria:\033[0m "
echo -e " \e[32m - Length: Generally 8-12 characters long.\033[0m"
echo -e " \e[32m - Complexity: May include a mix of character types but less varied.\033[0m"
echo -e " \e[32m - Predictability: May use common words or phrases.\033[0m"
echo
echo -e "\e[33mWeak Password Criteria:\033[0m "
echo -e " \e[32m - Length: Typically fewer than 8 characters.\033[0m"
echo -e " \e[32m - Complexity: Lacks variety; may consist of only lowercase letters or a simple combination of letters and numbers.\033[0m"
echo -e " \e[32m - Predictability: Uses common words, phrases, or easily guessable information.\033[0m"


calculate_strength() {
    local password="$1"
    local score=0

    # Length criteria
    length=${#password}
    if [ "$length" -ge 12 ] && [ "$length" -le 16 ]; then
        score=$((score + 30))
    elif [ "$length" -ge 8 ] && [ "$length" -lt 12 ]; then
        score=$((score + 20))
    elif [ "$length" -lt 8 ]; then
        score=$((score + 10))
    fi


    if [[ "$password" =~ [A-Z] ]] && [[ "$password" =~ [a-z] ]] && [[ "$password" =~ [0-9] ]] && [[ "$password" =~ [\!\@\#\$\%\^\&\*\(\)\_\+\=\{\}\[\]\:\;\"\'\<\>\,\.\?\/\\\|\`\~] ]]; then
        score=$((score + 30))
    elif [[ "$password" =~ [A-Z] ]] && [[ "$password" =~ [a-z] ]] && [[ "$password" =~ [0-9] ]] || [[ "$password" =~ [A-Z] ]] && [[ "$password" =~ [a-z] ]] && [[ "$password" =~ [\!\@\#\$\%\^\&\*\(\)\_\+\=\{\}\[\]\:\;\"\'\<\>\,\.\?\/\\\|\`\~] ]]; then
        score=$((score + 20))
    fi


    if echo "$password" | grep -Eiq "([a-zA-Z0-9])\1{2,}"; then
        score=$((score - 20))
    fi

    echo "$score"
}


suggest_strong_passwords() {
    local original_password="$1"
    local suggestions=()


    suggestions+=("$(echo "$original_password" | tr 'a-zA-Z' 'b-zA-Za')2024!") # Shift characters
    suggestions+=("Secure${original_password}#123")
    suggestions+=("123${original_password}!")
    suggestions+=("!${original_password}2024")
    suggestions+=("${original_password}@Secure")

    # Adding more suggestions to ensure five
    suggestions+=("$(echo "$original_password" | tr 'a-zA-Z' 'z-aZ-A')2024!")
    suggestions+=("Strong${original_password}#456")
    suggestions+=("!${original_password}2025$")
    suggestions+=("New${original_password}@2025")
    suggestions+=("Change${original_password}#Secure")


    echo "${suggestions[@]}"
}


YELLOW='\033[1;33m'
NC='\033[0m' 


read -sp "$(echo -e "\e[94mEnter your password:\033[0m ")" password
echo


strength=$(calculate_strength "$password")


if [ "$strength" -ge 80 ]; then
    echo -e  "\e[92mYour password is strong ($strength%).\033[0m"
elif [ "$strength" -ge 65 ] && [ "$strength" -lt 80 ]; then
    echo -e " \e[93mYour password is medium ($strength%)."
    echo -e "\e[96mConsider using a stronger password. Here's a suggestion: $(suggest_strong_passwords "$password" | head -n 1)\033[0m"
elif [ "$strength" -ge 15 ] && [ "$strength" -lt 65 ]; then
    echo -e "\e[91mYour password is weak ($strength%).\033[0m"
    echo -e "\e[96mHere are some stronger password suggestions:\033[0m"

    suggestions=$(suggest_strong_passwords "$password")
    count=0
    for suggestion in $suggestions; do
        if [ "$count" -lt 5 ]; then
            echo -e "${YELLOW}- $suggestion${NC}"
            count=$((count + 1))
        else
            break
        fi
    done
else
    echo -e "\e[31mYour password is very weak ($strength%). It's highly recommended to use a much stronger password.\033[0m"
    echo -e "\e[96mHere are five enhanced password suggestions based on your input:\033[0m"

    suggestions=$(suggest_strong_passwords "$password")
    count=0
    for suggestion in $suggestions; do
        if [ "$count" -lt 5 ]; then
            echo -e "${YELLOW}- $suggestion${NC}"
            count=$((count + 1))
        else
            break
        fi
    done
fi

