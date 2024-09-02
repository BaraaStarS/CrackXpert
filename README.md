# CrackXpert
**Secure&amp;Crack Suite**

CrackXpert is an automated password cracking suite designed to integrate and streamline multiple password-cracking tools into a unified interface. Built with Bash scripting, Crack Xpert provides a user-friendly CLI for performing password cracking tasks.

![crackXpert](https://github.com/user-attachments/assets/3db55124-967d-43bd-97b9-df524344acc0)


# Features 
1) Wordlist Generation: Generate custom wordlists based on user-provided information to improve the success rate of password cracking.
2) Hash Identification: Identify the type of hash.
3) Hash Calculation: Compute the hash of a given word using various popular hashing algorithms.
4) Password Strength Estimator: Estimate the strength of a password and suggest improvements or alternatives based on predefined criteria.
5) Integration with Cracking Tools:
   
   John the Ripper: Run password cracking tasks using John the Ripper.
   
   Hashcat: Use Hashcat for advanced password cracking.
   
   Hydra: Perform brute-force attacks on various services using Hydra.

   
# Installation
To set up CrackXpert, follow these steps:

1)Clone the Repository:

`
sudo git clone https://github.com/BaraaStarS/CrackXpert.git
`

2)Set Permissions: Make the main script and all scripts in the lib directory executable:

`
chmod +x crackxpert.sh lib/*.sh
`

3)Run CrackXpert:

`
./crackxpert.sh
`

