cask "claude-runner" do
  version "0.1.0"
  sha256 "1a508afcbe2484a8860cd60c1addbc07cc2b60437a4d4a2df0e93c4af2e36d36"

  url "https://github.com/jyami-kim/claude-runner/releases/download/v#{version}/claude-runner-#{version}.zip"
  name "claude-runner"
  desc "macOS menu bar app for monitoring Claude Code sessions"
  homepage "https://github.com/jyami-kim/claude-runner"

  depends_on macos: ">= :ventura"

  app "claude-runner.app"

  uninstall quit: "com.jyami.claude-runner",
            script: {
              executable: "/usr/bin/python3",
              args:       ["-c", <<~PYTHON],
import json, os, sys, shutil
# Remove hooks from ~/.claude/settings.json
p = os.path.expanduser('~/.claude/settings.json')
if os.path.exists(p):
    try:
        d = json.load(open(p))
        h = d.get('hooks', {})
        for k in list(h.keys()):
            entries = h[k]
            if isinstance(entries, list):
                h[k] = [e for e in entries if not any('claude-runner-hook.sh' in hook.get('command','') for hook in e.get('hooks',[]))]
                if not h[k]: del h[k]
        if not h: d.pop('hooks', None)
        else: d['hooks'] = h
        json.dump(d, open(p,'w'), indent=2, sort_keys=True)
    except: pass
# Remove Application Support data
shutil.rmtree(os.path.expanduser('~/Library/Application Support/claude-runner'), ignore_errors=True)
PYTHON
            }

  zap trash: [
    "~/Library/Application Support/claude-runner",
  ]
end
