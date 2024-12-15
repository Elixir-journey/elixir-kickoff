#!/bin/bash

echo "Starting post-start configuration..."

# 1. Load Environment Variables from `.env`
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "Environment variables loaded from .env"
else
    echo "No .env file found. Falling back to defaults."
fi

# 2. Configure Git User
echo "Applying user Git configuration..."

# Load user.name from gitconfig, .env, or fallback to "Unknown User"
GIT_USER_NAME=$(git config --global user.name || echo "${GIT_USER_NAME:-Unknown User}")
git config --global user.name "$GIT_USER_NAME"

# Load user.email from gitconfig, .env, or fallback to "unknown@example.com"
GIT_USER_EMAIL=$(git config --global user.email || echo "${GIT_USER_EMAIL:-unknown@example.com}")
git config --global user.email "$GIT_USER_EMAIL"

# Output the final values
echo "Git user.name: $(git config --global user.name)"
echo "Git user.email: $(git config --global user.email)"

# 3. Configure SSH
echo "Setting up SSH..."
eval "$(ssh-agent -s)"
if [ "$(ls -A ~/.ssh 2>/dev/null)" ]; then
    chmod 600 ~/.ssh/*
    ssh-add ~/.ssh/id_ed25519 2>/dev/null && echo "Added id_ed25519 to SSH agent."
    ssh-add ~/.ssh/id_rsa 2>/dev/null && echo "Added id_rsa to SSH agent."
else
    echo "No SSH key found. Please ensure keys are available in ~/.ssh."
fi

# 4. Test SSH and Fallback to HTTPS
echo "Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>/dev/null; then
    echo "SSH connection successful."
else
    echo "SSH connection failed. Falling back to HTTPS."
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ "$REMOTE_URL" == git@* ]]; then
        HTTPS_URL=$(echo "$REMOTE_URL" | sed -e 's/^git@github.com:/https:\/\/github.com\//')
        git remote set-url origin "$HTTPS_URL"
        echo "Updated remote URL to HTTPS: $HTTPS_URL"
    fi
fi

# 5. Authenticate with GitHub CLI (if available)
if command -v gh &> /dev/null; then
    echo "Authenticating with GitHub CLI..."
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "No GITHUB_TOKEN found in the environment. Please provide one in the .env file."
        exit 1
    fi
    echo "$GITHUB_TOKEN" | gh auth login --with-token || {
        echo "GitHub CLI authentication failed."
        exit 1
    }
    echo "Authenticated with GitHub CLI."
fi

# 6. Add Git Credentials for HTTPS
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring Git credentials for HTTPS..."
    git config --global credential.helper store
    echo "https://$GITHUB_TOKEN@github.com" > ~/.git-credentials
fi

echo "Post-start configuration complete!"
