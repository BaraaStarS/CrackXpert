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



suggest_stronger_password() {
    local password="$1"
    local new_password="$password"

    while [ ${#new_password} -lt 12 ]; do
        new_password+="$(echo $RANDOM | md5sum | head -c 1)"
    done

    if ! [[ "$new_password" =~ [A-Z] ]]; then
        new_password+="A"
    fi

    if ! [[ "$new_password" =~ [a-z] ]]; then
        new_password+="a"
    fi

    if ! [[ "$new_password" =~ [0-9] ]]; then
        new_password+="1"
    fi

    if ! [[ "$new_password" =~ [\@\#\$\%\^\&\*\(\)\-\+\=\!\?\>\<] ]]; then
        new_password+="@"
    fi

    echo "$new_password"
}

estimate_password_strength() {
    local password="$1"
    local score=0
    local length=${#password}

    if [ "$length" -ge 12 ]; then
        score=$((score + 25))
    elif [ "$length" -ge 8 ]; then
        score=$((score + 15))
    elif [ "$length" -ge 6 ]; then
        score=$((score + 5))
    fi

    
    if [[ "$password" =~ [A-Z] ]] && [[ "$password" =~ [a-z] ]]; then
        score=$((score + 20))
    fi

    
    if [[ "$password" =~ [0-9] ]]; then
        score=$((score + 20))
    fi

    
    if [[ "$password" =~ [\@\#\$\%\^\&\*\(\)\-\+\=\!\?\>\<] ]]; then
        score=$((score + 20))
    fi
    if ! [[ "$password" =~ (.)\1{2,} ]]; then
        score=$((score + 15))
    fi

    
    if ! [[ "$password" =~ 1234|abcd|password|qwerty ]]; then
        score=$((score + 10))
    fi

    
    if ! [[ "$password" =~ [a-zA-Z]{4} || "$password" =~ [0-9]{4} ]]; then
        score=$((score + 10))
    fi

    
    if [ "$score" -ge 80 ]; then
        echo -e "\e[92mStrong password\033[0m"
    elif [ "$score" -ge 50 ]; then
        echo -e "\e[93mMedium password\033[0m"
    else
        echo -e "\e[91mWeak password !!!!!! \033[0m"
        echo -e "\e[37mSuggested stronger password:\e[96m \e[36m $(suggest_stronger_password "$password")\e[96m "
    fi

    echo -e "\e[93m\e[47mScore: $score/100\033[0m"
}


read -s -p "$(echo -e "\e[94mEnter your password:\033[0m " )" user_password
echo


estimate_password_strength "$user_password"

