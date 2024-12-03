#!/bin/bash

# Define colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to log messages
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Retrieve Git email from gitconfig
GIT_EMAIL=$(git config --get user.email)

if [ -z "$GIT_EMAIL" ]; then
  log_error "Git email is not set in your gitconfig."
  echo "Set it with:"
  echo "  git config --global user.email 'your-email@example.com'"
  exit 1
fi
log_info "Using Git email: $GIT_EMAIL"

# Check if SSH keys already exist
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  log_info "No SSH key found. Generating one..."
  ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_rsa" -N ""
else
  log_info "SSH key already exists. Skipping key generation."
fi

# Start SSH agent and add the key
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/id_rsa"

# Display the public key
log_info "Your SSH public key:"
cat "$HOME/.ssh/id_rsa.pub"
log_info "Add this key to your GitHub account: https://github.com/settings/keys"

# Test SSH connection to GitHub
log_info "Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  log_info "SSH connection to GitHub is working correctly!"
else
  log_warning "SSH connection to GitHub failed. Ensure your key is added to GitHub."
  echo "Follow these steps to add your SSH key:"
  echo "1. Copy the public key displayed above."
  echo "2. Go to https://github.com/settings/keys."
  echo "3. Click 'New SSH Key', paste the key, and save."
fi

# Optional: Automate adding the key to GitHub via the API
read -p "Do you want to upload the SSH key to GitHub automatically? (y/N): " upload_key
if [[ "$upload_key" =~ ^[Yy]$ ]]; then
  read -p "Enter your GitHub username: " github_username
  read -sp "Enter your GitHub Personal Access Token: " github_token
  echo ""
  log_info "Uploading SSH key to GitHub..."
  
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -u "$github_username:$github_token" \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"title":"DevContainer SSH Key","key":"'"$(cat $HOME/.ssh/id_rsa.pub)"'"}' \
    https://api.github.com/user/keys)

  if [ "$RESPONSE" -eq 201 ]; then
    log_info "SSH key successfully uploaded to GitHub!"
  else
    log_error "Failed to upload SSH key to GitHub. Please check your credentials or token permissions."
  fi
else
  log_info "Skipping automatic upload of the SSH key to GitHub."
fi
