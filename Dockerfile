FROM elixir:1.17-alpine

# Set default environment to production, but allow override
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

# Install Hex and Rebar (build tools)
RUN mix do local.hex --force, local.rebar --force

WORKDIR /app

# Copy mix files and install dependencies based on the MIX_ENV
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

COPY . .

RUN mix compile

# Default command for general-purpose Elixir application
CMD ["mix", "run", "--no-halt"]
