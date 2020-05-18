#!/bin/sh
set -e

# Install Oh My Zsh
OHMYZSH=~/.oh-my-zsh
if  [ ! -d "$OHMYZSH" ]; then
  echo "Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Successfully installed Oh My Zsh"
fi

# Check if ~/.zshrc already exists and rename before overwrite.
ZSHRC=~/.zshrc
ZSHRC_OLD=~/.zshrc.old
if [ -f "$ZSHRC" ]; then
  mv "$ZSHRC" $ZSHRC_OLD
  echo "Move existing $ZSHRC to $ZSHRC_OLD"
fi

# Overwrite ~/.zshrc
cat ~/configs/zshrc > $ZSHRC
echo "Successfully write to $ZSHRC"
