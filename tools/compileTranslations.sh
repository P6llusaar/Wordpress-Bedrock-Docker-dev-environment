#!/bin/bash

# Set the path to the directory you want to monitor
directory="/var/www/html/web/app/languages"

if [[ ! -d "$directory" ]]; then
  mkdir "$directory"
fi

function compile_po() {
  po_file="$1"

  
  # Use wp cli to compile the po file into a mo file
  wp i18n make-json "${po_file}"
  wp i18n make-mo "${po_file}" 
}




last_modified=0


inotifywait -m -r -e modify "${directory}" |
while read path action file; do
    if [[ $file != *.[pP][oO] ]]; then
      continue
    fi

    current_time=$(date +%s)
    time_elapsed=$(( current_time - last_modified ))
    # For some reason we'll get an endless loop of updates. 
    # If less than a second has elapsed, skip this modification
    if [ "$time_elapsed" -lt 5 ]; then
        continue
    fi
    last_modified="$current_time"
    
    compile_po "${path}${file}"
done
