#!/bin/bash
# LostIP Installer/Uninstaller Script

GREEN="\033[92m"
RED="\033[91m"
YELLOW="\033[93m"
RESET="\033[0m"

echo -e "${GREEN}========================================${RESET}"
echo -e "${GREEN}        LostIP Installer v1.0           ${RESET}"
echo -e "${GREEN}========================================${RESET}\n"

read -rp "[?] Do you want to install LostIP (Y) or uninstall (N)? " choice

case "$choice" in
    [Yy])
        echo -e "\n[+] Installing LostIP..."
        
        chmod 755 lostip.sh
        mkdir -p /usr/share/lostip
        cp lostip.sh /usr/share/lostip/lostip.sh
        
        # Create wrapper
        cat <<'EOL' > /usr/bin/lostip
#!/bin/bash
exec /usr/share/lostip/lostip.sh "$@"
EOL
        
        chmod +x /usr/bin/lostip
        chmod +x /usr/share/lostip/lostip.sh
        
        echo -e "\n${GREEN}[✔] LostIP installed successfully!${RESET}"
        echo -e "    Run it with: ${YELLOW}lostip${RESET}\n"
    ;;
    
    [Nn])
        echo -e "\n[!] Uninstalling LostIP..."
        rm -rf /usr/share/lostip
        rm -f /usr/bin/lostip
        echo -e "${RED}[✔] LostIP removed.${RESET}\n"
    ;;
    
    *)
        echo -e "\n${RED}[✘] Invalid choice. Exiting.${RESET}\n"
        exit 1
    ;;
esac
