#!/bin/bash


loading_icon() {
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




handle_zip2john() {
  read -e -p "$(echo -e "\e[92mEnter the path to the zip file:\033[0m ")" zipfile
    if [ ! -f "$zipfile" ]; then
        echo -e "\e[91mFile not found!\033[0m"
        return
    fi

    echo -e "\e[93mRunning zip2john on $zipfile...\033[0m"
    zip2john "$zipfile" > temp.hash 2>/dev/null

    if [ ! -s temp.hash ]; then
        echo -e "\e[91mNo hash was generated. The file may not be encrypted or uses an unsupported compression type.\033[0m"
        return
    fi

    echo -e "\e[93mThe hash has been saved to temp.hash.\033[0m"
    
    read -e -p "$(echo -e "\e[92mDo you want to specify a wordlist? (y/n): [n using default wordlist /usr/share/wordlists/rockyou.txt]:\033[0m ")" use_wordlist

    if [ "$use_wordlist" == "y" ]; then
        read -e -p "$(echo -e "\e[92mEnter the path to the wordlist:\033[0m  ")" wordlist
        
        echo -e "\e[93mCracking with the provided wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john temp.hash --wordlist="$wordlist" >/dev/null 2>&1
    else
        echo -e "\e[93mCracking with default wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john temp.hash --wordlist=/usr/share/wordlists/rockyou.txt >/dev/null 2>&1
    fi

    echo -e "\e[45mCracking results:\033[0m"
    john --show temp.hash | awk -F: '{print "Password: "$2}'
    

    rm -f temp.hash
}





# rar2john
handle_rar2john() {
    read -e -p "$(echo -e "\e[92mEnter the path to the rar file:\033[0m ")" rarfile
    if [ ! -f "$rarfile" ]; then
        echo -e "\e[91mFile not found!\033[0m"
        return
    fi

    echo -e "\e[93mRunning rar2john on $rarfile...\033[0m"
    rar2john "$rarfile" > rar_hash.txt 2>/dev/null

    if [ ! -s rar_hash.txt ]; then
        echo -e "\e[91mNo hash was generated. The file may not be encrypted or uses an unsupported compression type.\033[0m"
        return
    fi

    echo -e "\e[93mThe hash has been saved to rar_hash.txt.\033[0m"

    read -e -p "$(echo -e "\e[92mDo you want to specify a wordlist? (y/n): [n using default wordlist /usr/share/wordlists/rockyou.txt]:\033[0m ")" use_wordlist
    if [ "$use_wordlist" == "y" ]; then
        read -e -p "$(echo -e "\e[92mEnter the path to the wordlist:\033[0m ")" wordlist
        echo -e "\e[93mCracking with the provided wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john rar_hash.txt --wordlist="$wordlist" >/dev/null 2>&1
    else
        echo -e "\e[93mCracking with default wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john rar_hash.txt --wordlist=/usr/share/wordlists/rockyou.txt >/dev/null 2>&1
    fi

    echo -e "\e[45mCracking results:\033[0m"
    john --show rar_hash.txt | awk -F: '{print "Password: "$2}'

    rm -f rar_hash.txt
}








# pdf2john
handle_pdf2john() {
    read -e -p "$(echo -e "\e[92mEnter the path to the PDF file:\033[0m ")" pdffile
    if [ ! -f "$pdffile" ]; then
        echo -e "\e[91mFile not found!\033[0m"
        return
    fi

    echo -e "\e[93mRunning pdf2john on $pdffile...\033[0m"
    pdf2john "$pdffile" > pdf_hash.txt 2>/dev/null

    if [ ! -s pdf_hash.txt ]; then
        echo -e "\e[91mNo hash was generated. The file may not be encrypted or uses an unsupported compression type.\033[0m"
        return
    fi

    echo -e "\e[93mThe hash has been saved to pdf_hash.txt.\033[0m"

    read -e -p "$(echo -e "\e[92mDo you want to specify a wordlist? (y/n): [n using default wordlist /usr/share/wordlists/rockyou.txt]:\033[0m ")" use_wordlist
    if [ "$use_wordlist" == "y" ]; then
        read -e -p "$(echo -e "\e[92mEnter the path to the wordlist:\033[0m ")" wordlist
        echo -e "\e[93mCracking with the provided wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john pdf_hash.txt --wordlist="$wordlist" >/dev/null 2>&1
    else
        echo -e "\e[93mCracking with default wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john pdf_hash.txt --wordlist=/usr/share/wordlists/rockyou.txt >/dev/null 2>&1
    fi

    echo -e "\e[45mCracking results:\033[0m"
    john --show pdf_hash.txt | awk -F: '{print "Password: "$2}'

    rm -f pdf_hash.txt
}





# 7z2john
handle_7z2john() {
    read -e -p "$(echo -e "\e[92mEnter the path to the 7z file:\033[0m ")" sevenzfile
    if [ ! -f "$sevenzfile" ]; then
        echo -e "\e[91mFile not found!\033[0m"
        return
    fi

    echo -e "\e[93mRunning 7z2john on $sevenzfile...\033[0m"
    7z2john "$sevenzfile" > 7z_hash.txt 2>/dev/null

    if [ ! -s 7z_hash.txt ]; then
        echo -e "\e[91mNo hash was generated. The file may not be encrypted or uses an unsupported compression type.\033[0m"
        return
    fi

    echo -e "\e[93mThe hash has been saved to 7z_hash.txt.\033[0m"

    read -e -p "$(echo -e "\e[92mDo you want to specify a wordlist? (y/n): [n using default wordlist /usr/share/wordlists/rockyou.txt]:\033[0m ")" use_wordlist
    if [ "$use_wordlist" == "y" ]; then
        read -e -p "$(echo -e "\e[92mEnter the path to the wordlist:\033[0m ")" wordlist
        echo -e "\e[93mCracking with the provided wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john 7z_hash.txt --wordlist="$wordlist" >/dev/null 2>&1
    else
        echo -e "\e[93mCracking with default wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john 7z_hash.txt --wordlist=/usr/share/wordlists/rockyou.txt >/dev/null 2>&1
    fi

    echo -e "\e[45mCracking results:\033[0m"
    john --show 7z_hash.txt | awk -F: '{print "Password: "$2}'

    rm -f 7z_hash.txt
}



# pcap2john
handle_pcap2john() {
    read -e -p "$(echo -e "\e[92mEnter the path to the pcap file:\033[0m ")" pcapfile
    if [ ! -f "$pcapfile" ]; then
        echo -e "\e[91mFile not found!\033[0m"
        return
    fi

    echo -e "\e[93mRunning pcap2john on $pcapfile...\033[0m"
    pcap2john "$pcapfile" > pcap_hash.txt 2>/dev/null

    if [ ! -s pcap_hash.txt ]; then
        echo -e "\e[91mNo hash was generated. The file may not contain hashes or uses an unsupported format.\033[0m"
        return
    fi

    echo -e "\e[93mThe hash has been saved to pcap_hash.txt.\033[0m"

    read -e -p "$(echo -e "\e[92mDo you want to specify a wordlist? (y/n): [n using default wordlist /usr/share/wordlists/rockyou.txt]:\033[0m ")" use_wordlist
    if [ "$use_wordlist" == "y" ]; then
        read -e -p "$(echo -e "\e[92mEnter the path to the wordlist:\033[0m ")" wordlist
        echo -e "\e[93mCracking with the provided wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john pcap_hash.txt --wordlist="$wordlist" >/dev/null 2>&1
    else
        echo -e "\e[93mCracking with default wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john pcap_hash.txt --wordlist=/usr/share/wordlists/rockyou.txt >/dev/null 2>&1
    fi

    echo -e "\e[45mCracking results:\033[0m"
    john --show pcap_hash.txt | awk -F: '{print "Password: "$2}'

    rm -f pcap_hash.txt
}




# hccap2john
handle_hccap2john() {
    read -e -p "$(echo -e "\e[92mEnter the path to the hccap file:\033[0m ")" hccapfile
    if [ ! -f "$hccapfile" ]; then
        echo -e "\e[91mFile not found!\033[0m"
        return
    fi

    echo -e "\e[93mRunning hccap2john on $hccapfile...\033[0m"
    hccap2john "$hccapfile" > hccap_hash.txt 2>/dev/null

    if [ ! -s hccap_hash.txt ]; then
        echo -e "\e[91mNo hash was generated. The file may not contain hashes or uses an unsupported format.\033[0m"
        return
    fi

    echo -e "\e[93mThe hash has been saved to hccap_hash.txt.\033[0m"

    read -e -p "$(echo -e "\e[92mDo you want to specify a wordlist? (y/n): [n using default wordlist /usr/share/wordlists/rockyou.txt]:\033[0m ")" use_wordlist
    if [ "$use_wordlist" == "y" ]; then
        read -e -p "$(echo -e "\e[92mEnter the path to the wordlist:\033[0m ")" wordlist
        echo -e "\e[93mCracking with the provided wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john hccap_hash.txt --wordlist="$wordlist" >/dev/null 2>&1
    else
        echo -e "\e[93mCracking with default wordlist...\033[0m"
        loading_icon 15 "$(echo -e "\e[95mCracking in progress\033[0m")"
        john hccap_hash.txt --wordlist=/usr/share/wordlists/rockyou.txt >/dev/null 2>&1
    fi

    echo -e "\e[95mCracking results:\033[0m"
    john --show hccap_hash.txt 



    rm -f hccap_hash.txt
}






while true; do
    echo -e "\033[0;36mChoose an option:\033[0m"
    echo -e "\033[0;36m1) zip2john \033[0m"
    echo -e "\033[0;36m2) rar2joh.\033[0m"
    echo -e "\033[0;36m3) pdf2john \033[0m"
    echo -e "\033[0;36m4) 7z2john \033[0m"
    echo -e "\033[0;36m5) pcap2john \033[0m"
    echo -e "\033[0;36m6) hccap2john\033[0m"
    echo -e "\033[0;31m7) Exit \033[0m"

read -p "$(echo -e "\e[92mEnter your choice:\e[0m ")" choice

clear

    case $choice in
        1) handle_zip2john ;;
        2) handle_rar2john ;;
        3) handle_pdf2john ;;
        4) handle_7z2john ;;
        5) handle_pcap2john ;;
        6) handle_hccap2john ;;
        7) handle_normal_crack ;;
        8) echo -e  "\e[36mExiting...\033[0m"; break ;;
        *) echo -e "\033[0;31mInvalid choice!\033[0m";;
    esac
done

