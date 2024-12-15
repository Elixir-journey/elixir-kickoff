# Builder stage
FROM elixir:1.17-alpine AS builder

ENV MIX_ENV=prod

# Install dependencies for building
RUN apk add --no-cache \
    git curl bash openssh postgresql-client

WORKDIR /app

# Install Hex and Rebar
RUN mix do local.hex --force, local.rebar --force

# Copy mix files and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy the rest of the application and compile
COPY . .
RUN mkdir -p /app/config /app/rel && mix compile

# Final stage
FROM elixir:1.17-alpine

ENV MIX_ENV=dev
ENV MIX_HOME=/root/.mix
ENV PATH="$MIX_HOME/escripts:$PATH"

# Install runtime dependencies and Zsh configuration tools
RUN apk add --no-cache \
    bash openssh postgresql-client \
    git curl zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
    && curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

WORKDIR /app

# Copy the compiled app from the builder stage
COPY --from=builder /app /app

# Install Hex and Rebar for runtime usage
RUN mix do local.hex --force, local.rebar --force

# Ensure escripts directory exists
RUN mkdir -p $MIX_HOME/escripts

# Pre-install Livebook or other escripts if needed
RUN mix escript.install hex livebook --force

# Configure Zsh with Powerlevel10k
RUN echo 'POWERLEVEL9K_MODE=nerdfont-complete' > /root/.p10k.zsh \
    && echo '[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh' > /root/.zshrc \
    && echo 'export ZSH_THEME="powerlevel10k/powerlevel10k"' >> /root/.zshrc \
    && echo "alias ll='ls -la'" >> /root/.zshrc \
    && echo 'export SHELL="/bin/zsh"' >> /root/.zshrc \
    && echo 'source /root/.zsh_plugins.sh' >> /root/.zshrc \
    && antibody bundle zsh-users/zsh-autosuggestions > /root/.zsh_plugins.sh \
    && antibody bundle zsh-users/zsh-syntax-highlighting >> /root/.zsh_plugins.sh \
    && antibody bundle romkatv/powerlevel10k >> /root/.zsh_plugins.sh

CMD ["/bin/zsh"]
