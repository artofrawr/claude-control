#!/usr/bin/env bash
# Validation script for the bazaar marketplace.
# Checks all plugins for correct structure, valid metadata, and marketplace consistency.
# Exit 0 on success, exit 1 if any errors are found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGINS_DIR="$REPO_ROOT/plugins"
MARKETPLACE="$REPO_ROOT/.claude-plugin/marketplace.json"

errors=()

err() {
  errors+=("ERROR: $1")
}

# --- Helper: check if string is lowercase kebab-case ---
is_kebab_case() {
  [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]
}

# --- Helper: check if string is semver ---
is_semver() {
  [[ "$1" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]
}

# --- Validate marketplace.json ---
if [[ ! -f "$MARKETPLACE" ]]; then
  err "marketplace.json not found at $MARKETPLACE"
  printf '%s\n' "${errors[@]}"
  exit 1
fi

if ! python3 -c "import json, sys; json.load(open(sys.argv[1]))" "$MARKETPLACE" 2>/dev/null; then
  err "marketplace.json is not valid JSON"
  printf '%s\n' "${errors[@]}"
  exit 1
fi

# Check marketplace plugins array is sorted alphabetically
sorted=$(python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
names = [p['name'] for p in data.get('plugins', [])]
print('yes' if names == sorted(names) else 'no')
" "$MARKETPLACE")
if [[ "$sorted" != "yes" ]]; then
  err "marketplace.json plugins array is not sorted alphabetically by name"
fi

# Get list of plugin names from marketplace.json
marketplace_names=$(python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
for p in data.get('plugins', []):
    print(p['name'])
" "$MARKETPLACE")

# Validate tags in marketplace entries
python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
for p in data.get('plugins', []):
    tags = p.get('tags')
    if tags is not None:
        if not isinstance(tags, list):
            print(f\"TAGS_ERR:{p['name']}:tags must be an array\")
            continue
        for t in tags:
            if not isinstance(t, str) or t != t.lower():
                print(f\"TAGS_ERR:{p['name']}:tag '{t}' must be a lowercase string\")
" "$MARKETPLACE" | while IFS= read -r line; do
  if [[ -n "$line" ]]; then
    plugin_name=$(echo "$line" | cut -d: -f2)
    msg=$(echo "$line" | cut -d: -f3-)
    err "marketplace.json entry '$plugin_name': $msg"
  fi
done

# --- Validate each plugin directory ---
if [[ ! -d "$PLUGINS_DIR" ]]; then
  err "plugins/ directory not found"
  printf '%s\n' "${errors[@]}"
  exit 1
fi

for plugin_dir in "$PLUGINS_DIR"/*/; do
  [[ -d "$plugin_dir" ]] || continue
  dir_name=$(basename "$plugin_dir")

  # Check directory name is kebab-case
  if ! is_kebab_case "$dir_name"; then
    err "Plugin directory '$dir_name' is not lowercase kebab-case"
  fi

  # Check plugin.json exists and is valid
  plugin_json="$plugin_dir/.claude-plugin/plugin.json"
  if [[ ! -f "$plugin_json" ]]; then
    err "Plugin '$dir_name': missing .claude-plugin/plugin.json"
    continue
  fi

  if ! python3 -c "import json, sys; json.load(open(sys.argv[1]))" "$plugin_json" 2>/dev/null; then
    err "Plugin '$dir_name': plugin.json is not valid JSON"
    continue
  fi

  # Check required fields
  validation=$(python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
dir_name = sys.argv[2]
issues = []
for field in ['name', 'description', 'version']:
    if field not in data:
        issues.append(f'missing required field: {field}')
if 'name' in data and data['name'] != dir_name:
    issues.append(f\"name '{data['name']}' does not match directory '{dir_name}'\")
print('\n'.join(issues))
" "$plugin_json" "$dir_name")

  if [[ -n "$validation" ]]; then
    while IFS= read -r issue; do
      err "Plugin '$dir_name': $issue"
    done <<< "$validation"
  fi

  # Check version is semver
  version=$(python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
print(data.get('version', ''))
" "$plugin_json")
  if [[ -n "$version" ]] && ! is_semver "$version"; then
    err "Plugin '$dir_name': version '$version' is not valid semver"
  fi

  # Check name is kebab-case
  pname=$(python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
print(data.get('name', ''))
" "$plugin_json")
  if [[ -n "$pname" ]] && ! is_kebab_case "$pname"; then
    err "Plugin '$dir_name': name '$pname' is not lowercase kebab-case"
  fi

  # Check README.md exists
  if [[ ! -f "$plugin_dir/README.md" ]]; then
    err "Plugin '$dir_name': missing README.md"
  fi

  # Check at least one SKILL.md exists with required frontmatter
  skill_count=0
  for skill_dir in "$plugin_dir"/skills/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_md="$skill_dir/SKILL.md"
    if [[ ! -f "$skill_md" ]]; then
      continue
    fi
    skill_count=$((skill_count + 1))

    # Check frontmatter fields
    fm_check=$(python3 -c "
import sys
path = sys.argv[1]
with open(path) as f:
    content = f.read()
if not content.startswith('---'):
    print('missing frontmatter')
    sys.exit()
parts = content.split('---', 2)
if len(parts) < 3:
    print('malformed frontmatter')
    sys.exit()
fm = parts[1]
issues = []
for field in ['name', 'description', 'disable-model-invocation']:
    if field + ':' not in fm:
        issues.append(f'missing frontmatter field: {field}')
print('\n'.join(issues))
" "$skill_md")
    if [[ -n "$fm_check" ]]; then
      skill_name=$(basename "$skill_dir")
      while IFS= read -r issue; do
        err "Plugin '$dir_name', skill '$skill_name': $issue"
      done <<< "$fm_check"
    fi
  done

  if [[ $skill_count -eq 0 ]]; then
    err "Plugin '$dir_name': no skills found (need at least one skills/<name>/SKILL.md)"
  fi

  # --- Validate commands (optional) ---
  if [[ -d "$plugin_dir/commands" ]]; then
    for cmd_file in "$plugin_dir"/commands/*.md; do
      [[ -f "$cmd_file" ]] || continue
      cmd_name=$(basename "$cmd_file" .md)
      cmd_fm_check=$(python3 -c "
import sys
path = sys.argv[1]
with open(path) as f:
    content = f.read()
if not content.startswith('---'):
    print('missing frontmatter')
    sys.exit()
parts = content.split('---', 2)
if len(parts) < 3:
    print('malformed frontmatter')
    sys.exit()
fm = parts[1]
issues = []
for field in ['name', 'description']:
    if field + ':' not in fm:
        issues.append(f'missing frontmatter field: {field}')
print('\n'.join(issues))
" "$cmd_file")
      if [[ -n "$cmd_fm_check" ]]; then
        while IFS= read -r issue; do
          err "Plugin '$dir_name', command '$cmd_name': $issue"
        done <<< "$cmd_fm_check"
      fi
    done
  fi

  # --- Validate agents (optional) ---
  if [[ -d "$plugin_dir/agents" ]]; then
    for agent_file in "$plugin_dir"/agents/*.md; do
      [[ -f "$agent_file" ]] || continue
      agent_name=$(basename "$agent_file" .md)
      agent_fm_check=$(python3 -c "
import sys
path = sys.argv[1]
with open(path) as f:
    content = f.read()
if not content.startswith('---'):
    print('missing frontmatter')
    sys.exit()
parts = content.split('---', 2)
if len(parts) < 3:
    print('malformed frontmatter')
    sys.exit()
fm = parts[1]
issues = []
for field in ['name', 'description', 'model', 'color']:
    if field + ':' not in fm:
        issues.append(f'missing frontmatter field: {field}')
# Validate model value
import re
model_match = re.search(r'model:\s*(.+)', fm)
if model_match:
    model_val = model_match.group(1).strip()
    if model_val not in ('inherit', 'sonnet', 'opus', 'haiku'):
        issues.append(f\"model '{model_val}' must be one of: inherit, sonnet, opus, haiku\")
# Validate color value
color_match = re.search(r'color:\s*(.+)', fm)
if color_match:
    color_val = color_match.group(1).strip()
    if color_val not in ('blue', 'cyan', 'green', 'yellow', 'magenta', 'red'):
        issues.append(f\"color '{color_val}' must be one of: blue, cyan, green, yellow, magenta, red\")
print('\n'.join(issues))
" "$agent_file")
      if [[ -n "$agent_fm_check" ]]; then
        while IFS= read -r issue; do
          err "Plugin '$dir_name', agent '$agent_name': $issue"
        done <<< "$agent_fm_check"
      fi
    done
  fi

  # --- Validate hooks (optional) ---
  if [[ -f "$plugin_dir/hooks/hooks.json" ]]; then
    if ! python3 -c "import json, sys; json.load(open(sys.argv[1]))" "$plugin_dir/hooks/hooks.json" 2>/dev/null; then
      err "Plugin '$dir_name': hooks/hooks.json is not valid JSON"
    else
      hooks_check=$(python3 -c "
import json, sys
data = json.load(open(sys.argv[1]))
issues = []
if 'hooks' not in data:
    issues.append('missing top-level \"hooks\" object')
elif not isinstance(data['hooks'], dict):
    issues.append('\"hooks\" must be an object')
else:
    for key, val in data['hooks'].items():
        if not isinstance(val, list):
            issues.append(f'hooks[\"{key}\"] must be an array')
print('\n'.join(issues))
" "$plugin_dir/hooks/hooks.json")
      if [[ -n "$hooks_check" ]]; then
        while IFS= read -r issue; do
          err "Plugin '$dir_name': hooks/hooks.json: $issue"
        done <<< "$hooks_check"
      fi
    fi
  fi

  # Check plugin has entry in marketplace.json
  if ! echo "$marketplace_names" | grep -qx "$dir_name"; then
    err "Plugin '$dir_name': no corresponding entry in marketplace.json"
  fi

  # --- Cross-check README skill table against actual skill directories ---
  readme_file="$plugin_dir/README.md"
  if [[ -f "$readme_file" ]]; then
    # Extract skill names from README table (bold entries like | **name** |)
    readme_skills=$(python3 -c "
import re, sys
with open(sys.argv[1]) as f:
    content = f.read()
for m in re.finditer(r'\|\s*\*\*([a-z0-9-]+)\*\*\s*\|', content):
    print(m.group(1))
" "$readme_file" | sort)

    # Get actual skill directory names
    actual_skills=""
    for sd in "$plugin_dir"/skills/*/; do
      [[ -d "$sd" ]] || continue
      sname=$(basename "$sd")
      if [[ -f "$sd/SKILL.md" ]]; then
        actual_skills="$actual_skills$sname"$'\n'
      fi
    done
    actual_skills=$(echo "$actual_skills" | sort | sed '/^$/d')

    # Find skills in README but not on disk (ghost skills)
    while IFS= read -r rs; do
      [[ -z "$rs" ]] && continue
      if ! echo "$actual_skills" | grep -qx "$rs"; then
        err "Plugin '$dir_name': README lists skill '$rs' but no skills/$rs/SKILL.md exists"
      fi
    done <<< "$readme_skills"

    # Find skills on disk but not in README (missing from docs)
    while IFS= read -r as; do
      [[ -z "$as" ]] && continue
      if ! echo "$readme_skills" | grep -qx "$as"; then
        err "Plugin '$dir_name': skill '$as' exists on disk but is not listed in README.md"
      fi
    done <<< "$actual_skills"
  fi
done

# --- Check marketplace entries point to existing plugin dirs ---
while IFS= read -r mp_name; do
  if [[ ! -d "$PLUGINS_DIR/$mp_name" ]]; then
    err "marketplace.json entry '$mp_name': no corresponding plugin directory"
  fi
done <<< "$marketplace_names"

# --- Report results ---
if [[ ${#errors[@]} -gt 0 ]]; then
  echo "Validation failed with ${#errors[@]} error(s):"
  echo ""
  for e in "${errors[@]}"; do
    echo "  $e"
  done
  exit 1
else
  echo "Validation passed. All plugins OK."
  exit 0
fi
