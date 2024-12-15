# Builder stage
FROM elixir:1.17-alpine AS builder

ENV MIX_ENV=prod

RUN mix do local.hex --force, local.rebar --force \
    && apk add --no-cache git curl bash openssh postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY . .
# Ensure directories exist
RUN mkdir -p /app/config /app/rel \
    && mix compile

# Final stage
FROM elixir:1.17-alpine

ENV MIX_ENV=dev

RUN apk add --no-cache \
    bash openssh postgresql-client \
    git curl zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
    && curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

WORKDIR /app

# Copy the entire project directory
COPY . /app

# Configure Zsh
RUN echo "export ZSH_THEME=\"robbyrussell\"" > /root/.zshrc \
    && echo "alias ll='ls -la'" >> /root/.zshrc \
    && echo "export SHELL=\"/bin/zsh\"" >> /root/.zshrc \
    && echo "source /root/.zsh_plugins.sh" >> /root/.zshrc \
    && antibody bundle zsh-users/zsh-autosuggestions > /root/.zsh_plugins.sh \
    && antibody bundle zsh-users/zsh-syntax-highlighting >> /root/.zsh_plugins.sh \
    && antibody bundle romkatv/powerlevel10k >> /root/.zsh_plugins.sh

CMD ["/bin/zsh"]
