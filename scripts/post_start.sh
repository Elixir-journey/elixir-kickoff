#!/bin/bash

echo "Starting post-start configuration..."

# 1. Load Environment Variables from `.env`
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "Environment variables loaded from .env"
else
    echo "No .env file found"
fi

# 2. Mount User's Git Configuration
if [ -f /root/.gitconfig ]; then
    echo "Git configuration already mounted."
else
    echo "Mounting Git configuration..."
    cp ~/.gitconfig /root/.gitconfig || echo "Failed to mount Git configuration."
fi

# 3. Dynamically Apply User Configuration
echo "Applying user Git configuration..."
git config --global user.name "${GIT_USER_NAME:-$(git config --global user.name || echo 'Unknown User')}"
git config --global user.email "${GIT_USER_EMAIL:-$(git config --global user.email || echo 'unknown@example.com')}"
echo "Git user.name: $(git config --global user.name)"
echo "Git user.email: $(git config --global user.email)"

# 4. Ensure SSH Keys Are Available
echo "Setting up SSH agent..."
eval "$(ssh-agent -s)"
if [ -f ~/.ssh/id_rsa ]; then
    ssh-add ~/.ssh/id_rsa || echo "Failed to add SSH key."
    echo "SSH key added successfully."
else
    echo "No SSH key found. Falling back to HTTPS and GitHub CLI."

    # 4.1 Install and Authenticate with GitHub CLI
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed. Please install it in the container."
        exit 1
    fi

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

    # 4.2 Convert SSH Remote URL to HTTPS if necessary
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    if [[ "$REMOTE_URL" == git@* ]]; then
        echo "Converting SSH remote URL to HTTPS..."
        HTTPS_URL=$(echo "$REMOTE_URL" | sed -e 's/^git@github.com:/https:\/\/github.com\//')
        git remote set-url origin "$HTTPS_URL"
        echo "Updated remote URL to HTTPS: $HTTPS_URL"
    else
        echo "Remote URL already using HTTPS or no remote URL set."
    fi
fi

# 5. Automate Setting Git Remote URLs (if SSH is available)
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [[ "$REMOTE_URL" == https://* ]]; then
    echo "Remote URL already using HTTPS."
else
    echo "Ensuring SSH URL is used..."
    SSH_URL=$(echo "$REMOTE_URL" | sed -e 's/^https:\/\//git@/' -e 's/github.com\//github.com:/')
    git remote set-url origin "$SSH_URL"
    echo "Updated remote URL to SSH: $SSH_URL"
fi

echo "Post-start configuration complete!"
