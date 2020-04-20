# Bootstrap a new Mac with apps and tools

Run `./setup_mac.sh` to bootstrap your mac with common apps and developer tools. The script is idempotent and is safe to be run multiple times.

Installs:

**Apps**
- Docker
- iTerm2
- Slack
- Spectacle
- Sublime
- Alfred
- Firefox
- 1Password


**Dev tools:**
- set up ssh keys for github
- clone bash_profile, iterm settings, sublime settings
  - symlinks settings files to proper locations
- go
- brew
  - ripgrep
  - tig
  - node
  - fzf
  - bat
  - hub
  - kubectl
  - helm
  - jq
  - kubectx
  - terraform
