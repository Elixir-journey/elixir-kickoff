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

# Create a vscode user and set permissions
RUN adduser -D -u 1000 vscode && \
    mkdir -p /home/vscode && \
    chmod 755 /home/vscode

# Set up the application directory
WORKDIR /workspace

# Copy mix files and install dependencies
COPY mix.exs mix.lock ./

RUN mix deps.get --only $MIX_ENV

# Copy the rest of the application code into /workspace
COPY . .

# Define a build argument for Git email
ARG GIT_EMAIL

# Copy the SSH setup script & make it executable
COPY scripts/setup-ssh.sh /home/vscode/setup-ssh.sh
RUN chmod +x /home/vscode/setup-ssh.sh

# Now chown /home/vscode to vscode
RUN chown -R vscode:vscode /home/vscode

# Switch to vscode user for future operations
USER vscode

# Run the setup script and pass the Git email
RUN /home/vscode/setup-ssh.sh "${GIT_EMAIL}"

# Switch back to root for application setup
USER root

# Run compilation in development mode
RUN mix compile

# Set the default user to vscode
USER vscode

# Default command to keep container running for VS Code
CMD ["sleep", "infinity"]
