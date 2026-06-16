# Project launcher — open any project folder in VSCode with fuzzy search
# Usage: p
# Requires: fzf (sudo apt install fzf)

# Set this to your projects folder
export PROJECTS_DIR="$HOME/projects"

p() {
  local dir
  dir=$(ls -d "$PROJECTS_DIR"/*/ 2>/dev/null | xargs -I{} basename {} | fzf --prompt="project: " --height=40% --reverse)
  [ -n "$dir" ] && code "$PROJECTS_DIR/$dir"
}
