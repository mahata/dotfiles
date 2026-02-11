#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

run_step() {
    local name="$1"
    shift
    local output
    local exit_code

    output=$("$@" 2>&1)
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        FAILED_STEPS+=("$name")
        log_error_persistent "install" "$name" "$exit_code" "$output"
        echo "⚠️  $name failed, continuing..."
        echo "$output"
    else
        [[ -n "$output" ]] && echo "$output"
    fi
}

log_info() {
    echo "$(date +'%Y-%m-%d %T') - $*"
}

log_error() {
    echo "$(date +'%Y-%m-%d %T') - ❌ $*"
}
