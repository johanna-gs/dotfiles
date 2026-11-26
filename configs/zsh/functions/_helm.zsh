#!/usr/bin/env zsh

alias ht=helm_template

# =========================
# Internal helpers
# =========================

_helmtpl_require() {
  for cmd in helm fzf; do
    command -v "$cmd" >/dev/null || { echo "$cmd not found"; return 1; }
  done
}

_helmtpl_detect_base() {
  if [ -n "${HELM_APPS_BASE:-}" ] && [ -d "$HELM_APPS_BASE" ]; then
    echo "$HELM_APPS_BASE"
  elif [ -d "argocd/apps/base" ]; then
    echo "argocd/apps/base"
  elif [ -d "apps/base" ]; then
    echo "apps/base"
  else
    return 1
  fi
}

_helmtpl_overlays_from_base() { echo "${1/base/overlays}"; }

_helmtpl_list_apps() {
  find "$1" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
}

_helmtpl_select() { fzf --prompt="$1"; }

_helmtpl_pick_app() {
  local base="$1" apps app
  apps="$(_helmtpl_list_apps "$base")"
  [ -n "$apps" ] || { echo "No apps in $base"; return 1; }
  app="$(echo "$apps" | _helmtpl_select "Select app: ")"
  [ -n "$app" ] || { echo "No app selected"; return 1; }
  echo "$app"
}

_helmtpl_pick_cluster() {
  local overlays="$1" app="${2:-}" clusters cluster c
  [ -d "$overlays" ] || { echo "Overlays directory not found: $overlays"; return 1; }
  clusters="$(_helmtpl_list_apps "$overlays")"
  if [ -n "$app" ]; then
    clusters="$(for c in ${(f)clusters}; do [ -d "$overlays/$c/$app" ] && echo "$c"; done)"
  fi
  [ -n "$clusters" ] || { echo "No clusters found in $overlays${app:+ containing $app}"; return 1; }
  cluster="$(echo "$clusters" | _helmtpl_select "Select cluster: ")"
  [ -n "$cluster" ] || { echo "No cluster selected"; return 1; }
  echo "$cluster"
}

_helmtpl_ensure_outdir() {
  mkdir -p "output"
  echo "output"
}

_helmtpl_build_deps() {
  local chart_dir="$1"
  [ -f "$chart_dir/Chart.yaml" ] || return 0
  [ "${HELM_SKIP_DEPS:-0}" = "1" ] && return 0
  local cmd="${HELM_DEP_CMD:-build}"   # build | update
  case "$cmd" in
    build|update) : ;;
    *) cmd="build" ;;
  esac
  echo "Resolving chart dependencies in: $chart_dir (helm dependency $cmd)"
  helm dependency "$cmd" "$chart_dir"
}

_helmtpl_render() {
  local app="$1" cluster="$2" chart_path="$3" suffix="$4"; shift 4
  local outdir; outdir="$(_helmtpl_ensure_outdir)"
  local outfile="$outdir/${app}-${cluster}${suffix}.yaml"

  helm template "$app" "$chart_path" \
    "$@" \
    --set-string "global.cluster=$cluster" \
    > "$outfile" || return $?

  echo "Rendered: $outfile"
}

# =========================
# Public entrypoint
# =========================
helm_template() {
  setopt LOCAL_OPTIONS NO_UNSET
  _helmtpl_require || return 1

  # --- Parse all args, extracting -s <suffix> and helm flags from positional args ---
  local suffix=""
  local -a helm_flags=()
  local -a pos_args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s)
        shift
        [[ $# -gt 0 ]] || { echo "-s requires an argument"; return 1; }
        suffix="-$1"
        ;;
      -*)
        helm_flags+=("$1")
        ;;
      *)
        pos_args+=("$1")
        ;;
    esac
    shift
  done
  # ---------------------------------------------------------------------------------

  # Early exit if repo structure missing
  local base; base="$(_helmtpl_detect_base)" || {
    echo "Error: not in a valid Helm repo (missing argocd/apps/base or apps/base or HELM_APPS_BASE)"
    return 1
  }
  local overlays; overlays="$(_helmtpl_overlays_from_base "$base")"
  [ -d "$overlays" ] || echo "Warning: overlays path not found: $overlays"

  local app="${pos_args[1]:-}"
  local cluster="${pos_args[2]:-}"

  [ -n "$app" ] || app="$(_helmtpl_pick_app "$base")"
  [ -n "$cluster" ] || cluster="$(_helmtpl_pick_cluster "$overlays" "$app")"

  local app_base_dir="$base/$app"
  [ -d "$app_base_dir" ] || { echo "App not found: $app_base_dir"; return 1; }

  local app_overlay_dir="$overlays/$cluster/$app"
  [ -d "$app_overlay_dir" ] || echo "Warning: overlay not found: $app_overlay_dir"

  local -a fargs=()
  [ -f "$app_base_dir/values.yaml" ]    && fargs+=(-f "$app_base_dir/values.yaml")
  [ -f "$app_overlay_dir/values.yaml" ] && fargs+=(-f "$app_overlay_dir/values.yaml")

  # Prefer the overlay's Chart.yaml when the cluster has one, else use base
  local chart_dir="$app_base_dir"
  [ -f "$app_overlay_dir/Chart.yaml" ] && chart_dir="$app_overlay_dir"

  _helmtpl_build_deps "$chart_dir" || {
    echo "Error: failed to resolve chart dependencies in $chart_dir"
    return 1
  }

  _helmtpl_render "$app" "$cluster" "$chart_dir" "$suffix" \
    "${fargs[@]}" \
    "${helm_flags[@]}"
}

helm_dep_update() {
  _helmtpl_require || return 1

  local base; base="$(_helmtpl_detect_base)" || {
    echo "Error: not in a valid Helm repo (missing argocd/apps/base or apps/base or HELM_APPS_BASE)"
    return 1
  }

  local app="${1:-}"
  [ -n "$app" ] || app="$(_helmtpl_pick_app "$base")"

  local overlays; overlays="$(_helmtpl_overlays_from_base "$base")"

  # Target: "base" or a cluster overlay; pick with fzf if not given
  local target="${2:-}"
  if [ -z "$target" ]; then
    local options="base" c
    if [ -d "$overlays" ]; then
      for c in $(_helmtpl_list_apps "$overlays"); do
        [ -f "$overlays/$c/$app/Chart.yaml" ] && options+=$'\n'"$c"
      done
    fi
    target="$(echo "$options" | _helmtpl_select "Select target: ")"
    [ -n "$target" ] || { echo "No target selected"; return 1; }
  fi

  local chart_dir="$base/$app"
  [ "$target" = "base" ] || chart_dir="$overlays/$target/$app"

  [ -d "$chart_dir" ] || { echo "App not found: $chart_dir"; return 1; }
  [ -f "$chart_dir/Chart.yaml" ] || { echo "No Chart.yaml in $chart_dir"; return 1; }

  echo "Updating dependencies for: $chart_dir"
  helm dependency update "$chart_dir"
}

alias hdu=helm_dep_update
