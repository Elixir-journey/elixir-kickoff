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
    postgresql-client \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zsh-completions \
    && curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

# Configure Zsh
RUN echo "export ZSH_THEME=\"robbyrussell\"" > /root/.zshrc \
    && echo "alias ll='ls -la'" >> /root/.zshrc \
    && echo "source /usr/share/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh" >> /root/.zshrc \
    && echo "export SHELL=\"/bin/zsh\"" >> /root/.zshrc \
    && antibody bundle zsh-users/zsh-autosuggestions > /root/.zsh_plugins.sh \
    && antibody bundle zsh-users/zsh-syntax-highlighting >> /root/.zsh_plugins.sh \
    && echo "source /root/.zsh_plugins.sh" >> /root/.zshrc

# Set up the application directory
WORKDIR /workspace

# Copy mix files and install dependencies
COPY ../mix.exs ../mix.lock /workspace/
RUN mix deps.get --only $MIX_ENV

# Copy the rest of the application code
COPY . .

# Ensure proper permissions for the workspace directory
RUN chown -R root:root /workspace

# Run compilation in development mode
RUN mix compile

# Launch Zsh as the default shell
CMD ["/bin/zsh"]
