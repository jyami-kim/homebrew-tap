cask "claude-runner" do
  version "0.1.0"
  sha256 "1a508afcbe2484a8860cd60c1addbc07cc2b60437a4d4a2df0e93c4af2e36d36"

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
