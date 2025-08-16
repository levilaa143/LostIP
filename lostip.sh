#!/bin/bash
# LostIP - Tor-based IP Rotator
# Developer: RlxChap2
# GitHub: https://github.com/RlxChap2

# ANSI color codes (custom)
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[94m"
CYAN="\033[96m"
PURPLE="\033[95m"
WHITE="\033[97m"

# Require root privileges
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${PURPLE}[!] Please run as root or with sudo.${RESET}"
        exit 1
    fi
}

# Install missing dependencies
install_dependencies() {
    echo -e "${CYAN}[+] Checking dependencies...${RESET}"
    for pkg in tor curl jq; do
        if ! command -v $pkg >/dev/null 2>&1; then
            echo -e "${BLUE}[!] $pkg not found. Installing...${RESET}"
            sudo apt update && sudo apt install -y $pkg
            echo -e "${CYAN}[+] $pkg installed.${RESET}"
        else
            echo -e "${WHITE}[✔] $pkg already installed.${RESET}"
        fi
    done
}

# Banner
display_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << "EOF"

██╗      ██████╗ ███████╗████████╗██╗██████╗
██║     ██╔═══██╗██╔════╝╚══██╔══╝██║██╔══██╗
██║     ██║   ██║███████╗   ██║   ██║██████╔╝
██║     ██║   ██║╚════██║   ██║   ██║██╔═══╝
███████╗╚██████╔╝███████║   ██║   ██║██║
╚══════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝

                  Developer: RlxChap2

EOF
    echo -e "${RESET}${BLUE}* GitHub: https://github.com/RlxChap2${RESET}\n"
    echo -e "${CYAN}Use SOCKS: 127.0.0.1:9050${RESET}\n"
}

# Start Tor
initialize_tor() {
    echo -e "${CYAN}[+] Starting Tor service...${RESET}"
    sudo systemctl start tor || sudo service tor start
    echo -e "${CYAN}[+] Tor service started.${RESET}"
}

# Stop Tor on exit
cleanup() {
    echo -e "${PURPLE}[!] Stopping Tor service...${RESET}"
    sudo systemctl stop tor || sudo service tor stop
    echo -e "${PURPLE}[!] Tor service stopped.${RESET}"
    exit 0
}
trap cleanup SIGINT SIGTERM

# Request new Tor identity
change_identity() {
    echo -e "${BLUE}[~] Requesting new identity...${RESET}"
    sudo systemctl reload tor || sudo service tor reload
    echo -e "${BLUE}[~] Identity changed.${RESET}"
}

# Show new IP + location
fetch_ip_and_location() {
    ip=$(curl -s --socks5 127.0.0.1:9050 --socks5-hostname 127.0.0.1:9050 http://httpbin.org/ip | jq -r .origin)
    if [ -z "$ip" ]; then
        echo -e "${PURPLE}[✘] Unable to fetch IP.${RESET}"
    else
        data=$(curl -s --socks5 127.0.0.1:9050 --socks5-hostname 127.0.0.1:9050 "https://ipapi.co/$ip/json/")
        country=$(echo "$data" | jq -r '.country_name')
        region=$(echo "$data" | jq -r '.region')
        city=$(echo "$data" | jq -r '.city')
        
        echo -e "${WHITE}[✔] New IP: ${CYAN}$ip${RESET}"
        echo -e "${WHITE}    Country: ${CYAN}$country${RESET}"
        echo -e "${WHITE}    Region : ${CYAN}$region${RESET}"
        echo -e "${WHITE}    City   : ${CYAN}$city${RESET}"
    fi
}

# Main loop
main() {
    display_banner
    initialize_tor
    
    echo -ne "${BLUE}[+] Interval between changes (sec) [default 60]: ${RESET}"
    read -r interval
    interval=${interval:-60}
    
    echo -ne "${BLUE}[+] Number of changes (0 = infinite): ${RESET}"
    read -r cycles
    cycles=${cycles:-0}
    
    if [[ "$cycles" -eq 0 ]]; then
        echo -e "${CYAN}[∞] Infinite mode. Press Ctrl+C to stop.${RESET}"
        while true; do
            sleep "$interval"
            change_identity
            fetch_ip_and_location
        done
    else
        for ((i = 1; i <= cycles; i++)); do
            sleep "$interval"
            change_identity
            fetch_ip_and_location
        done
    fi
}

check_sudo
install_dependencies
main
