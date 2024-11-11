#!/bin/bash

# Required environment variables for Livebook
export ELIXIR_ERL_OPTIONS="-epmd_module Elixir.Livebook.EPMD"
export LIVEBOOK_IP="0.0.0.0"

if [ -d "/workspace/livebook" ]; then
  BASE_DIR="/workspace/livebook"
elif [ -d "/workspaces/elixir-kickoff/livebook" ]; then
  BASE_DIR="/workspaces/elixir-kickoff/livebook"
else
  echo "Error: Could not find the Livebook directory."
  exit 1
fi

# Navigate to the Livebook directory
cd $BASE_DIR

# Start the Livebook server
mix phx.server
