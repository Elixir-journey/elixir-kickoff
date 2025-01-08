defmodule Mix.Tasks.PostStart do
  @shortdoc "Run post-start configuration"

  @moduledoc false
  use Mix.Task

  require Logger

  def run(_args) do
    Logger.info("Starting post-start configuration...")

    log_step("Loading environment variables", &load_environment_variables/0)
    log_step("Validating Git configuration", &validate_git_configuration/0)
    log_step("Configuring SSH", &configure_ssh/0)
    log_step("Setting up GitHub authentication", &setup_github_authentication/0)

    Logger.info("Post-start configuration complete!")
  end

  defp log_step(step_description, func) do
    Logger.info("Step: #{step_description}")

    try do
      func.()
    rescue
      e -> Logger.error("#{step_description} failed: #{inspect(e)}")
    end
  end

  defp load_environment_variables do
    if File.exists?(".env") do
      ".env"
      |> File.read!()
      |> String.split("\n")
      |> Enum.reject(&String.starts_with?(&1, "#"))
      |> Enum.each(&load_env_var/1)

      Logger.info("Environment variables loaded from .env")
    else
      Logger.info("No .env file found. Falling back to defaults.")
    end
  rescue
    e -> Logger.error("Failed to load environment variables: #{inspect(e)}")
  end

  defp load_env_var(line) do
    trimmed_line = String.trim(line)

    if trimmed_line == "" or String.starts_with?(trimmed_line, "#") do
      :ok
    else
      case String.split(trimmed_line, "=", parts: 2) do
        [key, value] -> System.put_env(key, value)
        _ -> Logger.error("Invalid .env line: #{line}")
      end
    end
  rescue
    e -> Logger.error("Error processing .env line: #{inspect(e)}")
  end

  defp validate_git_configuration do
    Logger.info("Validating Git configuration...")

    user_name = get_git_config("user.name") || "Unknown User"
    Logger.info("Git user.name: #{user_name}")

    user_email = get_git_config("user.email") || "unknown@example.com"
    Logger.info("Git user.email: #{user_email}")
  rescue
    e -> Logger.error("Error validating Git configuration: #{inspect(e)}")
  end

  defp get_git_config(key) do
    case System.cmd("git", ["config", "--global", key]) do
      {result, 0} -> String.trim(result)
      _ -> nil
    end
  rescue
    e ->
      Logger.error("Failed to retrieve Git config for #{key}: #{inspect(e)}")
      nil
  end

  defp configure_ssh do
    Logger.info("Setting up SSH...")

    System.cmd("ssh-agent", ["-s"])
    ssh_dir = Path.expand("~/.ssh")

    if File.dir?(ssh_dir) do
      ssh_dir
      |> File.ls!()
      |> Enum.each(&set_ssh_key_permissions(&1, ssh_dir))

      ssh_add("id_ed25519")
      ssh_add("id_rsa")
    else
      Logger.info("No SSH key found. Please ensure keys are available in ~/.ssh.")
    end

    test_ssh_connection()
  rescue
    e -> Logger.error("Error setting up SSH: #{inspect(e)}")
  end

  defp set_ssh_key_permissions(file, ssh_dir) do
    File.chmod!(Path.join(ssh_dir, file), 0o600)
  rescue
    e -> Logger.error("Error setting permissions for SSH key #{file}: #{inspect(e)}")
  end

  defp ssh_add(key) do
    key_path = Path.expand("~/.ssh/#{key}")

    if File.exists?(key_path) do
      System.cmd("ssh-add", [key_path])
      Logger.info("Added #{key} to SSH agent.")
    end
  rescue
    e -> Logger.error("Error adding SSH key #{key}: #{inspect(e)}")
  end

  defp test_ssh_connection do
    Logger.info("Testing SSH connection to GitHub...")

    case System.cmd("ssh", ["-T", "git@github.com"], stderr_to_stdout: true) do
      {output, 0} ->
        if String.contains?(output, "successfully authenticated") do
          Logger.info("#{output}")
        else
          Logger.error("SSH connection failed: #{output}")
          fallback_to_https()
        end

      {error_output, _} ->
        Logger.error("SSH connection failed: #{error_output}")
    end
  rescue
    e -> Logger.error("Error testing SSH connection: #{inspect(e)}")
  end

  defp fallback_to_https do
    case System.cmd("git", ["remote", "get-url", "origin"]) do
      {remote_url, 0} ->
        if String.starts_with?(remote_url, "git@github.com") do
          https_url = String.replace(remote_url, ~r/^git@github\.com:/, "https://github.com/")
          System.cmd("git", ["remote", "set-url", "origin", String.trim(https_url)])
          Logger.info("Updated remote URL to HTTPS: #{https_url}")
        else
          Logger.info("Remote URL does not use SSH. No changes made.")
        end

      _ ->
        Logger.info("No remote URL to update.")
    end
  end

  defp setup_github_authentication do
    Logger.info("Setting up GitHub authentication...")

    if System.find_executable("gh") do
      github_token = System.get_env("GITHUB_TOKEN")

      if github_token do
        authenticate_github_cli(github_token)
      else
        Logger.error("No GITHUB_TOKEN found in the environment. Please provide one in the .env file.")
      end
    else
      Logger.info("GitHub CLI not installed. Skipping authentication.")
    end
  end

  defp authenticate_github_cli(github_token) do
    case System.cmd("gh", ["auth", "login", "--with-token"], env: [{"GITHUB_TOKEN", github_token}]) do
      {_result, 0} -> Logger.info("Authenticated with GitHub CLI.")
      _ -> Logger.error("GitHub CLI authentication failed.")
    end
  rescue
    e -> Logger.error("Error during GitHub CLI authentication: #{inspect(e)}")
  end
end
