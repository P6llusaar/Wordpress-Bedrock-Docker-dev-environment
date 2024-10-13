#!/usr/bin/env bash

install_dump() {

    local file_path = $1

    if [ ! -f "$file_path" ]; then
        return
    fi

    if [[ "$file_path" != *.zip ]]; then
        return
    fi

    echo "new file added to dump folder, attempting to load..."

    script_file_path =$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
    cd "$script_file_path/.."

    echo "unpacking the archive..."
    unzip -q $file_path

    echo "copying over uploads..."
    cp -rf files/wp-content/uploads/* /var/www/html/web/app/uploads/
    echo "applying database dump..."
    wp db import database.sql --quiet

    echo "New version installed successfully, cleaning up..."

    rm -rf ./database.sql ./files wpmigrate-export.json $file_path

    echo "All done :)"
}



echo "Waiting for stuff to appear in dumps folder"

inotifywait -m -r -e modify "/dumps" |
while read path action file; do
    install_dump "/dumps/$file"
done



