# Elixir kickoff
This repository is a general-purpose Elixir project template designed to help you start new Elixir projects quickly. It includes essential configurations and Docker support.

## Features

- Basic Elixir setup with recommendations for commonly used dependencies.
- Docker support for running the application in an isolated environment.
- Dev Container for a fully configured, consistent development environment.
- Linting, documentation generation, and optional performance testing setup.

## Getting Started

### Development with devcontainers

If you’re using Visual Studio Code, elixir-kickoff provides a fully configured devcontainer environment. This setup ensures that all necessary tools (Elixir, Erlang, Hex, Rebar) are installed and available without any additional local setup.

1. Open the project in VS Code.
2. You should see a prompt: "Reopen in Container". Select it to open the project in the Dev Container.
3. Once inside the container, install dependencies and run the application:

```bash
mix deps.get
mix run --no-halt
```

### Running without devcontainers
If you’re not using devcontainers, you’ll need to have [Elixir and Erlang installed locally](https://elixir-lang.org/install.html). After installation, follow the same setup steps as above to fetch dependencies and start the application.

### Using Docker

The repository includes a Dockerfile that allows you to run the application in a container.

1. Build the Docker image

```bash
docker build -t elixir-kickoff .
```

2. Run the container

```bash
docker run elixir-kickoff
```


## Development Notes

- Environment Variables: Use .env files to manage environment variables. Make sure they are listed in .gitignore to keep sensitive information secure.
- Linting and Formatting: Run Credo for linting and mix format to ensure code consistency.
Contributing

## Contributing
If you have suggestions for improvements, feel free to submit a pull request or open an issue.