# CracXpert-
Secure&amp;Crack Suite
Crack Xpert is an automated password cracking suite designed to integrate and streamline multiple password-cracking tools into a unified interface. Built with Bash scripting, Crack Xpert provides a user-friendly CLI for performing password cracking tasks.
![crackXpert](https://github.com/user-attachments/assets/3db55124-967d-43bd-97b9-df524344acc0)
# Features 
--> Wordlist Generation: Generate custom wordlists based on user-provided information to improve the success rate of password cracking.
-- > Hash Identification: Identify the type of hash.
-- > Hash Calculation: Compute the hash of a given word using various popular hashing algorithms.
--> Password Strength Estimator: Estimate the strength of a password and suggest improvements or alternatives based on predefined criteria.
--> Integration with Cracking Tools:
John the Ripper: Run password cracking tasks using John the Ripper.
Hashcat: Use Hashcat for advanced password cracking.
Hydra: Perform brute-force attacks on various services using Hydra.
# Installation
To set up CrackXpert, follow these steps:

Clone the Repository:

bash
Copy code
sudo git clone https://github.com/BaraaStarS/CrackXpert.git
Set Permissions: Make the main script and all scripts in the lib directory executable:

bash
Copy code
chmod +x crackxpert.sh lib/*.sh
Run CrackXpert: Execute the main script to start the tool:

bash
Copy code
./crackxpert.sh

