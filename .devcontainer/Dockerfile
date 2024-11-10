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

# Set up the application directory
WORKDIR /workspace

# Copy mix files and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# Copy the rest of the application code
COPY . .

# Run compilation in development mode
RUN mix compile

# Default command to keep container running for VS Code
CMD ["sleep", "infinity"]
