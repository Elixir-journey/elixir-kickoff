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

# Clone the Livebook repository
RUN git clone https://github.com/livebook-dev/livebook.git /workspace/livebook

# Install Elixir dependencies for Livebook
WORKDIR /workspace/livebook
RUN mix deps.get

# Install JavaScript dependencies for assets
WORKDIR /workspace/livebook/assets
RUN npm install

# Copy the start_livebook.sh script and make it executable
WORKDIR /workspace
COPY scripts/start_livebook.sh /workspace/start_livebook.sh
RUN chmod +x /workspace/start_livebook.sh

# Set the working directory back to the Livebook root directory
WORKDIR /workspace/livebook

# Expose the ports Livebook uses
EXPOSE 4000 4001

# Set environment variables for Livebook
ENV ELIXIR_ERL_OPTIONS="-epmd_module Elixir.Livebook.EPMD"
ENV LIVEBOOK_IP="0.0.0.0"

# Default command to keep the container running
CMD ["sleep", "infinity"]
