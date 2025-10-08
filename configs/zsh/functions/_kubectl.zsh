#!/usr/bin/env zsh

kubectl_exec_into_pod() {
    local pod_name

    # If a pod name is provided as argument, use it
    if [ $# -gt 0 ]; then
        pod_name="$1"
    else
        # Otherwise, use fzf to select a pod
        pod_name=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | fzf --prompt="Select pod: " --height=40% --reverse)

        # Exit if no pod was selected
        if [ -z "$pod_name" ]; then
            echo "No pod selected"
            return
        fi
    fi

    echo "Execing into pod $pod_name"
    kubectl exec --stdin --tty "$pod_name" -- /bin/bash
}

kubectl_describe_pod() {
    local pod_name

    if [ $# -gt 0 ]; then
        pod_name="$1"
    else
        pod_name=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | \
            fzf --prompt="Select pod to describe: " \
                --height=40% --reverse \
                --preview='kubectl describe pod {}' \
                --preview-window=right:70%:wrap:follow | \
                    awk '{print $1}')

        if [ -z "$pod_name" ]; then
            echo "No pod selected"
            return
        fi
    fi

    kubectl describe pod "$pod_name"
}

kubectl_logs() {
    local pod_name

    if [ $# -gt 0 ]; then
        pod_name="$1"
        shift  # Remove the first argument so we can pass remaining args to kubectl logs
    else
        pod_name=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | \
            fzf --prompt="Select pod for logs: " \
                --height=40% \
                --reverse \
                --preview='kubectl logs {} --tail=50' \
                --preview-window=right:70%:wrap:follow)

        if [ -z "$pod_name" ]; then
            echo "No pod selected"
            return
        fi
    fi

    kubectl logs "$pod_name" "$@"
}

kubectl_get() {
    local resource_type resource_name

    # If arguments are provided, use them
    if [ $# -gt 0 ]; then
        kubectl get "$@"
        return
    fi

    # Select resource type
    resource_type=$(echo "pods\ndeployments\nservices\nstatefulsets\ndaemonsets\ningresses\nconfigmaps\nsecrets\npvc\nnodes" | \
        fzf --prompt="Select resource type: " \
            --height=40% \
            --reverse)

    if [ -z "$resource_type" ]; then
        echo "No resource type selected"
        return
    fi

    # Select specific resource
    resource_name=$(kubectl get "$resource_type" --no-headers -o custom-columns=":metadata.name" | \
        fzf --prompt="Select $resource_type: " \
            --height=40% \
            --reverse \
            --preview="kubectl get $resource_type {} -o yaml" \
            --preview-window=right:70%:wrap:follow)

    if [ -z "$resource_name" ]; then
        echo "No resource selected"
        return
    fi

    kubectl get "$resource_type" "$resource_name" -o yaml
}


kubectl_port_forward() {
    local pod_name local_port remote_port

    # If arguments are provided, use them directly
    # Usage: kubectl_port_forward pod-name 8080:80
    if [ $# -gt 0 ]; then
        kubectl port-forward "$@"
        return
    fi

    # Shows all pods with a preview of their running containers and ports
    pod_name=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | \
        fzf --prompt="Select pod to port-forward: " \
            --height=40% \
            --reverse \
            --preview='kubectl get pod {} -o jsonpath="{.spec.containers[*].ports[*].containerPort}" | tr " " "\n" | sort -u | sed "s/^/Container port: /"' \
            --preview-window=right:40%:wrap:follow)

    if [ -z "$pod_name" ]; then
        echo "No pod selected"
        return
    fi

    # This shows what ports the containers are actually listening on
    echo "\nAvailable container ports in pod '$pod_name':"
    kubectl get pod "$pod_name" -o jsonpath='{.spec.containers[*].ports[*].containerPort}' | tr ' ' '\n' | sort -u

    echo -n "\nEnter remote port (port on the pod): "
    read remote_port

    if [ -z "$remote_port" ]; then
        echo "No remote port specified"
        return
    fi

    # Defaults to the same as remote port if not specified
    echo -n "Enter local port (port on your machine, press enter for same as remote): "
    read local_port

    # If no local port specified, use the remote port
    if [ -z "$local_port" ]; then
        local_port="$remote_port"
    fi

    # Start port forwarding
    echo "\nPort forwarding $local_port:$remote_port to pod $pod_name"
    echo "Access the service at http://localhost:$local_port"
    echo "Press Ctrl+C to stop port forwarding\n"

    kubectl port-forward "$pod_name" "$local_port:$remote_port"
}
