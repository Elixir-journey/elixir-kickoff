# Use an official Elixir image as the base
FROM elixir:1.17-alpine

# Set default environment to development
ENV MIX_ENV=dev

# Install Hex, Rebar, and essential tools
RUN mix do local.hex --force, local.rebar --force \
    && apk add --no-cache \
    git \
    nodejs \
    npm \
    curl \
    inotify-tools \
    bash \
    openssh \
    postgresql-client

# Install GitHub CLI (gh)
RUN apk add --no-cache github-cli

# Ensure .ssh directory exists
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Set up the application directory
WORKDIR /workspace

# Copy mix files and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# Copy the rest of the application code
COPY . .

# Ensure proper permissions for the workspace directory
RUN chown -R root:root /workspace

# Run compilation in development mode
RUN mix compile

# Default command for better interactive experience
CMD ["/bin/bash"]
