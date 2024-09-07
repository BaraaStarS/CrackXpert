#!/bin/bash


function show_info() {
    echo -e "\e[34mThis script calculates hashes for the given word using various algorithms.\033[0m"
    echo -e "\e[34mSupported hash types and their purposes:\033[0m"
    echo -e "  \e[35m1. MD4: Designed for fast hashing, mainly used in legacy applications.\033[0m"
    echo -e "  \e[35m2. MD5: Commonly used to verify data integrity but vulnerable to collisions.\033[0m"
    echo -e "  \e[35m3. SHA1: Used in security applications, more secure than MD5 but now considered weak.\033[0m"
    echo -e "  \e[35m4. SHA224: A truncated version of SHA256, used for efficiency in certain applications.\033[0m"
    echo -e "  \e[35m5. SHA256: Widely used in security protocols and blockchain, providing strong security.\033[0m"
    echo -e "  \e[35m6. SHA384: Provides a higher level of security than SHA256 with a larger digest size.\033[0m"
    echo -e "  \e[35m7. SHA512: Offers even stronger security with a 512-bit digest, used in highly sensitive applications.\033[0m"
    echo -e "  \e[35m8. SHA3-256: Part of the SHA-3 family, designed for post-quantum security.\033[0m"
    echo
}


function calculate_hash() {
    local word="$1"
    local hash_type="$2"

    case "$hash_type" in
        1) echo "MD4:    $(echo -n "$word" | openssl dgst -md4 | awk '{print $2}')" ;;
        2) echo "MD5:    $(echo -n "$word" | openssl dgst -md5 | awk '{print $2}')" ;;
        3) echo "SHA1:   $(echo -n "$word" | openssl dgst -sha1 | awk '{print $2}')" ;;
        4) echo "SHA224: $(echo -n "$word" | openssl dgst -sha224 | awk '{print $2}')" ;;
        5) echo "SHA256: $(echo -n "$word" | openssl dgst -sha256 | awk '{print $2}')" ;;
        6) echo "SHA384: $(echo -n "$word" | openssl dgst -sha384 | awk '{print $2}')" ;;
        7) echo "SHA512: $(echo -n "$word" | openssl dgst -sha512 | awk '{print $2}')" ;;
        8) echo "SHA3-256: $(echo -n "$word" | openssl dgst -sha3-256 | awk '{print $2}')" ;;
        *) echo "Invalid selection. Please choose a valid option." ;;
    esac
}


show_info


read -p "$(echo -e "\e[94mEnter a word to convert it to hash:\033[0m ")" word


if [ -z "$word" ]; then
    echo "Error: No word provided."
    exit 1
fi

read -p "$(echo -e "\e[94mSelect the hash type you want to calculate (Enter the number 1-8):\033[0m ")" hash_type

echo
echo -e " \e[95mCalculating the hash for the word:\033[0m $word"
calculate_hash "$word" "$hash_type"


exit 0

