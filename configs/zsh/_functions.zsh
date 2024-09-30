#!/usr/bin/env zsh

RED='\033[0;32m'
NC='\033[0m' # No Color

# Utility functions
functions command_exists() {
  command -v "$@" >/dev/null 2>&1
}

functions reload() {
    if [ -f  $HOME/.zshenv ]; then
        source $HOME/.zshrc
        clear
        echo "${RED}󰑌 .zshrc reloaded${NC}"
    fi
}

functions kubectl_exec_into_pod() {
    if [ $# -eq 0 ]; then
        echo "No pod name supplied in arguments"
        return
    fi
    echo "Execing into pod $1";
    kubectl exec --stdin --tty $1 -- /bin/bash
}


functions kubectl_psql_start() {
    PGPASSWORD_POSTGRES=$(kubectl get secret --namespace default timescaledb-credentials -o jsonpath="{.data.PATRONI_SUPERUSER_PASSWORD}" | base64 --decode)

    kubectl run -i --tty --rm psql --image=postgres \
        --env "PGPASSWORD=$PGPASSWORD_POSTGRES" \
        --command -- psql -U postgres -h timescaledb.default.svc.cluster.local postgres
}

functions docker_exec_into_container() {
    if [ $# -eq 0 ]; then
        echo "No container name supplied in arguments"
        return
    fi
    echo "Execing into container $1";
    docker exec -i -t $1 /bin/bash
}

functions fix_wsl_clock() {
    sudo ntpdate pool.ntp.org
}
