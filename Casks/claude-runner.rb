cask "claude-runner" do
  version "0.3.0"
  sha256 "2b0258a9b5c177e23c0b2006462f2c0a22f082a983cf679b17c89110dcc1d973"

  url "https://github.com/jyami-kim/claude-runner/releases/download/v#{version}/claude-runner-#{version}.zip"
  name "claude-runner"
  desc "macOS menu bar app for monitoring Claude Code sessions"
  homepage "https://github.com/jyami-kim/claude-runner"

  depends_on macos: ">= :ventura"
  depends_on formula: "jq"

  app "claude-runner.app"

  uninstall quit: "com.jyami.claude-runner",
            script: {
              executable: "/usr/bin/python3",
              args:       ["-c", <<~PYTHON],
import json, os, shutil
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
shutil.rmtree(os.path.expanduser('~/Library/Application Support/claude-runner'), ignore_errors=True)
PYTHON
            }

  zap trash: [
    "~/Library/Application Support/claude-runner",
  ]
end
