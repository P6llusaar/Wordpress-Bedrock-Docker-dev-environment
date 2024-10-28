#!/usr/bin/env bash
set -Eeuo pipefail

cd /var/www/html
composer install

start_script() {
    local script="$1"

    while true; do
        echo "Starting $script..."
        "$script"
        sleep 2
        echo "$script kicked the bucket, restarting..."
    done
}

for script in /tools/*; do
    if [[ ! -x "$script" ]]; then 
        chmod +x "$script"
    fi

    start_script "$script" &
done

#starts apache
exec "$@"