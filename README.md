# config

My tmux setup. It is built for tmux 3.4+ (tested on 3.7b), zsh, and iTerm2 on a Mac connecting
over ssh or Eternal Terminal.

```
tmux/tmux.conf            -> ~/.tmux.conf            base config: prefix C-a, vi keys, plugins
tmux/conf.d/main/*.conf   -> ~/.config/tmux/conf.d/  theme, copy mode, agent keys, menus (main host)
tmux/conf.d/nested/*.conf -> ~/.config/tmux/conf.d/  lighter variant for a remote tmux opened from inside the main one
bin/tmux-park             -> ~/.local/bin/           "park" a pane/window in a hidden __parked session
bin/agent-status-line     -> ~/.local/bin/           status-bar agent counts (prints nothing when unused)
```

`~/.tmux.conf` loads every `~/.config/tmux/conf.d/*.conf` (`source-file -q`) just before TPM, so the
fragments override the base file. Install **one** variant of the fragments per host: `main` or
`nested`, never both.

## What you get

- Prefix **`C-a`** (`C-a a` sends a literal C-a). `|` / `-` split, `h j k l` move between panes, vi copy mode.
- **Mouse off** on purpose: iTerm's own selection and Cmd+C/Cmd+V always work. tmux's OSC52
  clipboard copies did not reach the Mac over Eternal Terminal. Scroll with `Alt+Up` / `Alt+Down` (or
  `prefix [`); `q` leaves copy mode. With `set -g mouse on` you get click-to-focus, wheel scrolling and
  right-click menus (`50-mouse-menus.conf`); then hold Option to select text in iTerm.
- **Persistence:** tmux-resurrect + tmux-continuum save every 5 min and restore on server start;
  `timvw/tmux-assistant-resurrect` also restores the exact Claude Code / Codex sessions running in panes.
  Manual: `prefix C-s` save, `prefix C-r` restore.
- **Theme:** dark grey / amber status bar at the top (`#S`, window and pane counts, PREFIX indicator,
  host, clock); pane borders show the pane number, directory, and an agent's name and state.
- **Agent keys** (main variant): `prefix S` opens an agent dashboard popup, `prefix g` a jump-to-agent
  menu, `prefix T` sets the pane topic (`@tmux-pane-topic`). The nested variant only has `prefix T`.
- Unchanged tmux defaults that are worth knowing: `prefix D` (choose client), `prefix z` (zoom a pane;
  handy before selecting text so the selection doesn't spill into the neighbouring pane).

### The optional agent supervisor

`prefix S`, `prefix g`, the agent counts in the status bar, and the coloured window dots
(red = waiting for input, green = working, grey = idle) come from a separate private agent-supervisor
setup. It provides `~/.local/bin/agent-dashboard`, `agent-jump`, and a poller that sets the pane
options `@agent` and `@agent-state` and writes `~/.local/state/agent-supervisor/tmux-status`. None of
that is in this repo. Without it, everything else works: the dots and counts stay empty, and `S`/`g`
just flash and close.

## Recreate the setup (instructions for an agent)

Run these steps on the target host. Look before you overwrite: back up existing files with a
timestamp before replacing them.

1. **Check prerequisites.**
   ```bash
   tmux -V          # need >= 3.4 (3.2+ works, but root `M-Down` needs 3.5+; see step 4)
   command -v zsh git
   ```
   Note whether a tmux server is running (`tmux ls`). If one is, do **not** kill it: the user's
   sessions live there. Reload the config instead (step 6).

2. **Clone this repo** (if it isn't already at `~/work/config`).
   ```bash
   git clone https://github.com/movb/config.git ~/work/config
   ```

3. **Back up, then install the base config.**
   ```bash
   ts=$(date +%Y%m%d%H%M%S)
   [ -e ~/.tmux.conf ] && cp ~/.tmux.conf ~/.tmux.conf.bak.$ts
   cp ~/work/config/tmux/tmux.conf ~/.tmux.conf
   ```
   The base config sets `default-shell /bin/zsh`. If zsh lives elsewhere (`command -v zsh`), edit
   that line.

4. **Install one fragment variant.** Use `main` for the host you sit on (the outer tmux). Use
   `nested` for a remote host whose tmux you attach to from inside the main tmux. That variant has
   no mouse settings, puts its status bar at the bottom so the two bars don't collide, and only
   binds `prefix T`.
   ```bash
   variant=main     # or: nested
   mkdir -p ~/.config/tmux/conf.d
   [ -n "$(ls -A ~/.config/tmux/conf.d 2>/dev/null)" ] && cp -r ~/.config/tmux/conf.d ~/.config/tmux/conf.d.bak.$ts
   rm -f ~/.config/tmux/conf.d/*.conf
   cp ~/work/config/tmux/conf.d/$variant/*.conf ~/.config/tmux/conf.d/
   ```
   On tmux older than 3.5, `copy-mode -d` doesn't exist. If installing `main` there, delete the
   line `bind -n M-Down copy-mode -d` from `30-copy-mode.conf` (the nested variant already omits it).

5. **Install the helper scripts and TPM.**
   ```bash
   mkdir -p ~/.local/bin
   cp ~/work/config/bin/tmux-park ~/work/config/bin/agent-status-line ~/.local/bin/
   chmod +x ~/.local/bin/tmux-park ~/.local/bin/agent-status-line
   [ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
   Plugins come from GitHub. If the host has no direct internet access, use its HTTP(S) proxy
   (for example `git config --global https.proxy http://<proxy>:<port>`) or copy `~/.tmux/plugins`
   from another machine.
   On first load, tmux-assistant-resurrect adds `SessionStart`/`SessionEnd` hooks to
   `~/.claude/settings.json` (this is how it tracks Claude session ids). That is expected; leave them.

6. **Load it, then install the plugins.** TPM reads the plugin list from a running server, so load first.
   - No tmux server running: `tmux new-session -d -s main`.
   - Server already running: `tmux source-file ~/.tmux.conf`. This re-applies everything except
     options that only change for new clients (terminal overrides); detach and reattach to get those.
   ```bash
   ~/.tmux/plugins/tpm/bin/install_plugins     # resurrect, continuum, assistant-resurrect (= prefix I)
   tmux source-file ~/.tmux.conf               # activate them
   ```

7. **Verify** and report what you checked:
   ```bash
   tmux show -g prefix                        # prefix C-a
   tmux show -g mouse                         # mouse off
   tmux show -g status-position               # top (main) / bottom (nested)
   tmux list-keys | grep -E ' (S|g|T) '       # agent keys (main: S g T; nested: T)
   tmux show -g @continuum-save-interval      # 5
   ls ~/.tmux/plugins                         # tpm tmux-resurrect tmux-continuum tmux-assistant-resurrect
   ```
   Then press `prefix C-s`; tmux should print "Tmux environment saved!".

### Nested-host note

On the remote host I currently load the two plugins without TPM. These lines in its
`~/.tmux.conf` replace the plugin/continuum block and the TPM `run` line:
```tmux
set -g @resurrect-capture-pane-contents "on"
run-shell ~/.tmux/plugins/tmux-resurrect/resurrect.tmux
run-shell ~/.tmux/plugins/tmux-assistant-resurrect/tmux-assistant-resurrect.tmux
source-file -q ~/.config/tmux/conf.d/*.conf
```
The TPM version from step 3 works there too. The only difference is that continuum autosaves.

## Rollback

`cp ~/.tmux.conf.bak.<ts> ~/.tmux.conf`, restore `~/.config/tmux/conf.d.bak.<ts>` (or delete
`~/.config/tmux/conf.d`), then `tmux source-file ~/.tmux.conf`.

## Troubleshooting

- **`git clone` over ssh hangs inside an old tmux pane** after reconnecting with Eternal Terminal/ssh:
  the pane's `SSH_AUTH_SOCK` still points to the old connection's agent socket. Fix the pane with
  `export SSH_AUTH_SOCK=$(tmux show-env SSH_AUTH_SOCK | cut -d= -f2)`.
- **Text selection doesn't reach the Mac clipboard:** the mouse must be off (`tmux show -g mouse`),
  or hold Option while dragging.
