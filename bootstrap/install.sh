#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/Arrr-temm/codex-config.git}"
BRANCH="${BRANCH:-main}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
VENDOR_IMPORTS="$CODEX_HOME/vendor_imports"
REPO_DIR="$VENDOR_IMPORTS/codex-config"
BIN_DIR="$HOME/.local/bin"

log() {
  printf '[codex-config] %s\n' "$1"
}

ensure_dir() {
  mkdir -p "$1"
}

backup_file() {
  local path="$1"
  if [ -f "$path" ]; then
    cp "$path" "$path.bak.$(date +%Y%m%d-%H%M%S)"
  fi
}

sync_tree() {
  local src="$1"
  local dest="$2"
  ensure_dir "$dest"
  find "$src" -mindepth 1 -maxdepth 1 | while read -r item; do
    base="$(basename "$item")"
    target="$dest/$base"
    if [ -d "$item" ]; then
      rm -rf "$target"
      cp -R "$item" "$target"
    else
      if [ -e "$target" ]; then
        backup_file "$target"
      fi
      cp "$item" "$target"
    fi
  done
}

if ! command -v git >/dev/null 2>&1; then
  echo "git is required to install codex-config." >&2
  exit 1
fi

ensure_dir "$CODEX_HOME"
ensure_dir "$VENDOR_IMPORTS"
ensure_dir "$BIN_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -d "$LOCAL_REPO_ROOT/.git" ]; then
  log "Updating local checkout in $LOCAL_REPO_ROOT"
  git -C "$LOCAL_REPO_ROOT" fetch origin "$BRANCH"
  git -C "$LOCAL_REPO_ROOT" checkout "$BRANCH"
  git -C "$LOCAL_REPO_ROOT" pull --ff-only origin "$BRANCH"
  SOURCE_ROOT="$LOCAL_REPO_ROOT"
else
  if [ ! -d "$REPO_DIR/.git" ]; then
    log "Cloning $REPO_URL into $REPO_DIR"
    git clone --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
  else
    log "Updating checkout in $REPO_DIR"
    git -C "$REPO_DIR" fetch origin "$BRANCH"
    git -C "$REPO_DIR" checkout "$BRANCH"
    git -C "$REPO_DIR" pull --ff-only origin "$BRANCH"
  fi
  SOURCE_ROOT="$REPO_DIR"
fi

MANAGED_ROOT="$SOURCE_ROOT/codex"

if [ -f "$MANAGED_ROOT/config.toml" ]; then
  log "Syncing config.toml"
  backup_file "$CODEX_HOME/config.toml"
  cp "$MANAGED_ROOT/config.toml" "$CODEX_HOME/config.toml"
fi

if [ -d "$MANAGED_ROOT/skills" ]; then
  log "Syncing skills"
  sync_tree "$MANAGED_ROOT/skills" "$CODEX_HOME/skills"
fi

if [ -d "$MANAGED_ROOT/rules" ]; then
  log "Syncing rules"
  sync_tree "$MANAGED_ROOT/rules" "$CODEX_HOME/rules"
fi

cat > "$BIN_DIR/get-codex-config" <<EOF
#!/usr/bin/env bash
exec "$SOURCE_ROOT/bootstrap/install.sh"
EOF
chmod +x "$BIN_DIR/get-codex-config"

for profile in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$profile" ]; then
    if ! grep -q 'codex-config PATH' "$profile"; then
      {
        echo
        echo '# codex-config PATH'
        echo 'export PATH="$HOME/.local/bin:$PATH"'
      } >> "$profile"
    fi
  fi
done

log "Install complete. Open a new shell and run: get-codex-config"
