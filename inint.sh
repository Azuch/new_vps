#!/bin/bash

# Function to print a message in a nice format
print_message() {
  echo
  echo "===================================="
  echo "$1"
  echo "===================================="
  echo
}

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Step 1: Install Zsh
print_message "Installing Zsh..."
if command -v apt-get >/dev/null; then
  sudo apt update
  sudo apt install -y zsh
elif command -v dnf >/dev/null; then
  sudo dnf install -y zsh
elif command -v pacman >/dev/null; then
  sudo pacman -S --noconfirm zsh
else
  echo "Unsupported package manager. Install Zsh manually."
  exit 1
fi

# Step 2: Install Oh My Zsh
print_message "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Step 3: Install zsh-autosuggestions
print_message "Installing zsh-autosuggestions..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Step 4: Enable the plugin
print_message "Enabling zsh-autosuggestions plugin..."
ZSHRC="$HOME/.zshrc"
if ! grep -q "zsh-autosuggestions" "$ZSHRC"; then
  sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' "$ZSHRC"
else
  echo "zsh-autosuggestions is already enabled in $ZSHRC"
fi

# Step 5: Install python3-venv, tmux, python3-pip
print_message "Installing python3-venv, tmux, python3-pip..."
if command -v apt-get >/dev/null; then
  sudo apt update
  sudo apt install -y python3-venv tmux python3-pip
elif command -v dnf >/dev/null; then
  sudo dnf install -y python3-venv tmux python3-pip
elif command -v pacman >/dev/null; then
  sudo pacman -S --noconfirm python3-venv tmux python3-pip
else
  echo "Unsupported package manager. Install python3-venv, tmux, python3-pip manually."
  exit 1
fi

# Step 6: Change default shell to Zsh
print_message "Changing default shell to Zsh..."
chsh -s $(which zsh)

# Step 7: Apply changes
print_message "Applying changes..."
source "$ZSHRC"

print_message "Installation and configuration complete! Please restart your terminal."
