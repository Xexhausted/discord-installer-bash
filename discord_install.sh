#!/bin/bash

uninstall_discord() {
    read -p "This will uninstall Discord. Proceed? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        if grep -qi "arch" /etc/os-release; then
            echo "Detected Arch-based system."
            sudo pacman -Rns --noconfirm discord 2>/dev/null || true
            sudo rm -rf /opt/Discord
        elif grep -qiE "debian|ubuntu" /etc/os-release; then
            echo "Detected Debian-based system."
            sudo apt remove --purge -y discord 2>/dev/null || true
            sudo rm -rf /opt/Discord
        else
            echo "Unsupported system. Discord manually removed."
            sudo rm -rf /opt/Discord
            exit 1
        fi
    else
        echo "Uninstallation canceled."
        exit 0
    fi
}

install_discord() {
    pkill Discord 2>/dev/null || true
    uninstall_discord

    cd ~
    wget -O discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"
    tar -xzf discord.tar.gz

    sudo mv Discord /opt/
    sudo ln -sf /opt/Discord/Discord /usr/bin/discord

    rm discord.tar.gz
    echo "Discord installed........"
}

install_discord
