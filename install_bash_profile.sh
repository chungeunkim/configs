#!/bin/sh
set -e

# Check if ~/.bash_profile already exists and rename before overwrite.
BASH_PROFILE=~/.bash_profile
BASH_PROFILE_OLD=~/.bash_profile.old
if [ -f "$BASH_PROFILE" ]; then
  mv "$BASH_PROFILE" ~/.bash_profile.old
  echo "Move existing $BASH_PROFILE to $BASH_PROFILE_OLD"
fi

# Overwrite bash_profile
cat ~/configs/bash_profile > $BASH_PROFILE
echo "Successfully write to ~/.bash_profile"
