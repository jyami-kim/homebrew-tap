cask "claude-runner" do
  version "0.1.0"
  sha256 "43e47b9d46e11a30880a5a1fad6acb5e7e483b72990ed6c13d569c315138de4d"

  url "https://github.com/jyami-kim/claude-runner/releases/download/v#{version}/claude-runner-#{version}.zip"
  name "claude-runner"
  desc "macOS menu bar app for monitoring Claude Code sessions"
  homepage "https://github.com/jyami-kim/claude-runner"

  depends_on macos: ">= :ventura"

  app "claude-runner.app"

  zap trash: [
    "~/Library/Application Support/claude-runner",
  ]
end
