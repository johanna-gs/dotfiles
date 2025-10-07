#!/usr/bin/env zsh

helm_dependencies_build() {
  if [[ ! -d "apps" ]]; then
        echo "Error: This function must be run from a directory that contains an 'apps' directory"
        echo "Current directory: $PWD"
        return 1
  fi

  if [[ $# -ne 1 ]]; then
        echo "Usage: helm_deps_build <APPNAME>"
        echo "Example: helm_deps_build myApp"
        return 1
  fi

  local APPNAME=$1

  helm dependencies build "./apps/base/$APPNAME/"
}

helm_dependencies_update() {
  if [[ ! -d "apps" ]]; then
        echo "Error: This function must be run from a directory that contains an 'apps' directory"
        echo "Current directory: $PWD"
        return 1
  fi

  if [[ $# -ne 1 ]]; then
        echo "Usage: helm_deps_update <APPNAME>"
        echo "Example: helm_deps_update myApp"
        return 1
  fi

  local APPNAME=$1

  helm dependencies update "./apps/base/$APPNAME/"
}

helm_template() {
  if [[ ! -d "apps" ]]; then
      echo "Error: This function must be run from a directory that contains an 'apps' directory"
      echo "Current directory: $PWD"
      return 1
  fi

  if [[ $# -ne 2 ]]; then
      echo "Usage: helm_template <APPNAME> <CLUSTER>"
      echo "Example: helm_template myApp myCluster"
      return 1
  fi

  local APPNAME="$1"
  local CLUSTER="$2"

  helm template $APPNAME "./apps/base/$APPNAME/" -f "./apps/base/$APPNAME/values.yaml" -f "./apps/overlays/$CLUSTER/$APPNAME/values.yaml" --set-string "global.cluster=$CLUSTER" > output.yaml

  echo "Helm template generated and saved to output.yaml"
}
