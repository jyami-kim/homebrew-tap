cask "claude-runner" do
  version "0.3.3"
  sha256 "814963fae0753b0a4cf119b1d723213b7c5c992db2024f412076b2f1e4448328"

  url "https://github.com/jyami-kim/claude-runner/releases/download/v#{version}/claude-runner-#{version}.zip"
  name "claude-runner"
  desc "macOS menu bar app for monitoring Claude Code sessions"
  homepage "https://github.com/jyami-kim/claude-runner"

  depends_on macos: ">= :ventura"
  depends_on formula: "jq"

  app "claude-runner.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/claude-runner.app"]
    system_command "/usr/bin/open",
                   args: ["#{appdir}/claude-runner.app"]
  end

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
