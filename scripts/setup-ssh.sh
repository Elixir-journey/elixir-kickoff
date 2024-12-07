#!/bin/bash

# Define colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Log message functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to retrieve Git email
get_git_email() {
  local email
  email=$(git config --get user.email)

  if [ -z "$email" ]; then
    log_error "Git email is not set in your gitconfig."
    echo "Set it with:"
    echo "  git config --global user.email 'your-email@example.com'"
    exit 1
  fi
  echo "$email"
}

# Function to generate SSH key
generate_ssh_key() {
  local email=$1
  local key_path="$HOME/.ssh/id_rsa"

  if [ -f "$key_path" ]; then
    log_info "SSH key already exists. Skipping key generation."
  else
    log_info "No SSH key found. Generating one..."
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$key_path" -N ""
    log_info "SSH key generated at $key_path."
  fi
}

# Function to configure SSH
configure_ssh() {
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_rsa"
  log_info "SSH key added to the SSH agent."

  log_info "Your SSH public key:"
  cat "$HOME/.ssh/id_rsa.pub"
  log_info "Add this key to your GitHub account: https://github.com/settings/keys"
}

# Function to test GitHub SSH connection
test_github_ssh() {
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
}

# Function to upload SSH key to GitHub via API
upload_ssh_key_to_github() {
  local username token response
  read -p "Enter your GitHub username: " username
  read -sp "Enter your GitHub Personal Access Token: " token
  echo ""

  log_info "Uploading SSH key to GitHub..."
  response=$(curl -s -o /dev/null -w "%{http_code}" -u "$username:$token" \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"title":"DevContainer SSH Key","key":"'"$(cat $HOME/.ssh/id_rsa.pub)"'"}' \
    https://api.github.com/user/keys)

  if [ "$response" -eq 201 ]; then
    log_info "SSH key successfully uploaded to GitHub!"
  else
    log_error "Failed to upload SSH key to GitHub. Please check your credentials or token permissions."
  fi
}

# Main script execution
main() {
  GIT_EMAIL=$(get_git_email)
  log_info "Using Git email: $GIT_EMAIL"

  generate_ssh_key "$GIT_EMAIL"
  configure_ssh
  test_github_ssh

  # Prompt for GitHub key upload
  read -p "Do you want to upload the SSH key to GitHub automatically? (y/N): " upload_key
  if [[ "$upload_key" =~ ^[Yy]$ ]]; then
    upload_ssh_key_to_github
  else
    log_info "Skipping automatic upload of the SSH key to GitHub."
  fi
}

main "$@"