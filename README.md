# Elixir kickoff
This repository is a general-purpose Elixir project template designed to help you quickly start new projects. It includes essential configurations and Docker support.

## Features

- Basic Elixir setup with recommendations for commonly used dependencies.
- Docker support for running the application in an isolated environment.
- Dev Container for a fully configured, consistent development environment.
- Linting, documentation generation, and optional performance testing setup.

## Getting Started

### Development Setup

#### Auto-Formatting, Linting, and Error Reporting
This project includes a set of tools to ensure code quality and consistency. These tools are configured to run automatically on save, giving you immediate feedback as you work.

1. Code formatting with [Elixir Formatter](https://hexdocs.pm/mix/main/Mix.Tasks.Format.html)

It ensures any code follows a consistent style. The Elixir Formatter is set to run automatically on save, formatting your code to follow standard Elixir conventions.

The .formatter.exs file controls settings, and auto-formatting is enabled in .vscode/settings.json.

2. Linting with [Credo](https://hexdocs.pm/credo/overview.html)

It enforces best practices and code consistency by highlighting potential readability and maintainability issues. Credo runs automatically on save through ElixirLS, displaying warnings and suggestions directly in the editor. You can also run ```mix credo``` in the terminal for a complete linting check.

3. Type Checking and Error Reporting with [Dialyzer](https://www.erlang.org/doc/apps/dialyzer/dialyzer_chapter.html)

It analyzes code for type errors and potential bugs, offering an additional layer of safety. Dialyzer is integrated with ElixirLS, running in the background and reporting issues as you work.
The initial setup may take a few minutes, as it builds a PLT (Persistent Lookup Table) with necessary type information.

#### Development with devcontainers

##### Requirements

- [Docker](https://www.docker.com) (for running containers)
- [Visual Studio Code](https://code.visualstudio.com)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

If using Visual Studio Code, elixir-kickoff provides a fully configured devcontainer environment. This setup ensures that all necessary tools (Elixir, Erlang, Hex, Rebar) are installed and available without any additional local setup.

1. Open the project in VS Code.
2. You should see a prompt: "Reopen in Container". Select it to open the project in the Dev Container. Alternatively, open the Command Palette (Ctrl+Shift+P or Cmd+Shift+P) and search for ```Remote-Containers: Reopen in Container```.
3. Once inside the container, install dependencies and run the application:

```bash
mix deps.get
mix run --no-halt
```

#### Customization and Configuration

The Dev Container uses a pre-built Docker image for faster setup and consistent environments across all sessions. The image is hosted on GitHub Container Registry at [ghcr.io/elixir-journey/elixir-kickoff:latest](https://github.com/orgs/Elixir-journey/packages/container/package/elixir-kickoff).

Extensions: The following VS Code extensions are automatically installed:
- Elixir Language Server (Elixir LS)
- Docker
- GitLens
- Spell Checker
- Prettier (for code formatting)
- Material Icon Theme

You can modify the .devcontainer/devcontainer.json file to add extensions or dependencies.

### Running without devcontainers
If you’re not using devcontainers, you must have [Elixir and Erlang installed locally](https://elixir-lang.org/install.html). After installation, follow the same setup steps as above to fetch dependencies and start the application.

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

## Code style & editor configuration
This project uses an .editorconfig file to ensure consistent coding standards across different editors and environments. The .editorconfig file helps maintain consistent formatting for:

- Indentation: Spaces with a width of 4.
- Line endings: LF (Line Feed) for cross-platform compatibility.
- Trimming trailing whitespace and final newline insertion for cleaner diffs.

### How It Works

If you’re using Visual Studio Code or another modern editor, the settings will be applied automatically if you have [EditorConfig support](https://editorconfig.org). The VS Code Dev Container setup includes this support by default, so no extra setup is needed.

## Development Notes

- Environment Variables: Use .env files to manage environment variables. Make sure they are listed in .gitignore to keep sensitive information secure.
- Linting and Formatting: Run Credo for linting and mix format to ensure code consistency.
Contributing

## Contributing
Feel free to submit a pull request or open an issue if you have improvement suggestions.
