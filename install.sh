#!/bin/bash

# Update package list and install zsh
sudo apt update
sudo apt install -y zsh wget

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh plugins
plugins=(
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
  marlonrichert/zsh-autocomplete
)

for plugin in "${plugins[@]}"; do
  plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$(basename $plugin)"
  if [ ! -d "$plugin_dir" ]; then
    git clone https://github.com/$plugin $plugin_dir
  fi
done

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# Create a new .zshrc file with the specified settings
cat << 'EOF' > "$HOME/.zshrc"
# Set ZSH variable to the Oh My Zsh installation path
export ZSH="$HOME/.oh-my-zsh"

# Enable Powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Add plugins
plugins=(
  git
  git
  python
  docker
  kubectl
  gcloud
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

# Key bindings for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# to keep container history
export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history

# Other settings can be added here
EOF

# Set Zsh as the default shell
chsh -s $(which zsh)

# Source the new .zshrc in the current shell
source "$HOME/.zshrc"

# Print a message indicating that the script has finished
echo "Installation complete! Please restart your terminal."
