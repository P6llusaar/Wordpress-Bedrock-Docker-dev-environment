#!/bin/bash

cd /var/www/html/web/app/languages

# Usage: setup_translation_watcher <relative_path> <plugin/theme folder> <file_name_without_extension>
# Example: setup_translation_watcher "path/to/parentfolder" "pluginfolder" "your-plugin"

function setup_translation_watcher(){
    relative_path="$1"
    folder_name="$2"
    file_name="$3"
    language_code="$4"

    watched_folder="../${relative_path}/${folder_name}/"
    file_path_prefix="${relative_path}/${file_name}"

    # Start monitoring the directory for changes to po files
    inotifywait -m -r -e modify "../${relative_path}/${folder_name}" |
    while read path action file; do

        if [[ $file != *.[pP][hH][pP] ]]; then
            continue
        fi

        new_pot_content=$(wp i18n make-pot "$watched_folder" -)
        orig_pot_content=$(cat "${file_path_prefix}.pot")


        filtered_new=$(echo "$new_pot_content" | grep -v '^"POT-Creation-Date:')
        filtered_orig=$(echo "$orig_pot_content" | grep -v '^"POT-Creation-Date:')
        if [[ "$filtered_new" = "$filtered_orig" ]]; then
            #translations stayed the same
            continue
        fi


        echo "Detected change in ${file}. Updating translation files..."
        
        touch "${file_path_prefix}.pot"
        echo "$filtered_new" > "${file_path_prefix}.pot"
        wp i18n update-po "${file_path_prefix}.pot" "${file_path_prefix}-${language_code}.po"

        echo "PO file generated"
    done

}


#(et is Estonian language code)
#translation file name is usually the same as plugin/theme name
#If you want to check multiple folders add & at the end of the command

#setup_translation_watcher "themes" "twentytwentyfour" "twentytwentyfour" "et" &
#setup_translation_watcher "plugins" "plugin_name" "translation_file_name" "et"

