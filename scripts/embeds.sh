#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
EMBEDS_PATH="${1:-"$EMBEDS_PATH"}"
OUTPUT_FILE="${2:-"$OUTPUT_FILE"}"
HEAD_FILE="${3:-"$HEAD_FILE"}"
EMBEDS_PATH="${EMBEDS_PATH:-"$SCRIPT_PATH/embeds"}"
OUTPUT_FILE="${OUTPUT_FILE:-"$SCRIPT_PATH/embeds.html"}"
HEAD_FILE="${HEAD_FILE:-"$SCRIPT_PATH/head.html"}"

if ! [ -d "$EMBEDS_PATH" ]; then
    echo "Error: Directory \"${EMBEDS_PATH}\" not found."
    exit 2
fi

if ! [ -d "$(dirname "${OUTPUT_FILE}")" ]; then
    echo "Error: Directory for output file \"${OUTPUT_FILE}\" not  found."
    exit 3
fi

if ! [ -f "${HEAD_FILE}" ]; then
    echo "Error: HTML Head \"${HEAD_FILE}\" not found."
    exit 4
fi

# Function to get a space-separated list of files with specified extensions in a directory
# Usage: get_files_with_extensions <directory_path> <extension1> [<extension2> ...]
get_files_with_extensions() {
    # Check if at least two arguments are provided
    if [ "$#" -lt 2 ]; then
        echo "Usage: get_files_with_extensions <directory_path> <extension1> [<extension2> ...]"
        exit 1
    fi

    local dir_path="$1"
    shift

    # Create an empty variable to store file names
    local files_list=""

    # Iterate through the provided extensions
    for extension in $@; do
        # Use find command to find files with specified extensions and add them to the list
        for element in $(find "$dir_path" -type f -iname "*.$extension"); do
            files_list="$files_list $element"
        done
    done

    # Return the space-separated list of file names with specified extensions
    echo "$files_list"
}

extensions="gif png jpg bmp"
files="$(get_files_with_extensions "$EMBEDS_PATH" "$extensions")"

# Function to generate an HTML page with links to files
# Usage: generate_html_page <output_file> <file1> [<file2> ...]
generate_html_page() {
    # Check if at least two arguments are provided
    if [ "$#" -lt 3 ]; then
        echo "Usage: generate_html_page <output_file> <head file> <file1> [<file2> ...]"
        return 1
    fi

    local output_file="$1"
    shift

    local head_file="$1"
    shift

    # Generate the HTML page with links to the files
    cat "$head_file" > "$output_file"
    echo "<html lang=\"en-US\">" >> "$output_file"
    echo "<body>" >> "$output_file"

    # Iterate through the files_list and generate links
    for file in $@; do
        file_name="$(basename "$file")"
        file_name="${file_name%.*}"
        echo "<img src=\"${file}\" alt=\":${file_name}:\"/>" >> "$output_file"
    done

    echo "</body>" >> "$output_file"
    echo "</html>" >> "$output_file"

    echo "HTML page generated at: $output_file"
}

generate_html_page "$OUTPUT_FILE" "$HEAD_FILE" "$files"

