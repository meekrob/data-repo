#!/usr/bin/env bash
# initialize or evaluate a data directory
# I used https://chatgpt.com/share/68bf18fe-4a58-8010-b51c-38d190d80829
#!/usr/bin/env bash
#
# Usage: datadir [options] file[s]
#

set -euo pipefail

# Defaults
name=""
destination=""
move_method="cp"

show_help() {
    cat << EOF
Usage: datadir [options] file[s]

Options:
  -h, --help            Show this help message and exit
  -n, --name NAME       Name to use for the operation (overrides destination)
  -d, --destination DIR Destination directory (ignored if --name is set)
  -m, --move-method M   Move method: mv, cp, hardlink, softlink (default: "$move_method")
EOF
}

# Parse arguments
files=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--name)
            name="$2"
            shift 2
            ;;
        -d|--destination)
            destination="$2"
            shift 2
            ;;
        -m|--move-method)
            move_method="$2"
            shift 2
            ;;
        -*)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
        *)
            files+=("$1")
            shift
            ;;
    esac
done

# Check required arguments
if [[ ${#files[@]} -eq 0 ]]; then
    echo "Error: No input files provided" >&2
    show_help
    exit 1
fi

# Validate move_method
case "$move_method" in
    mv|cp|hardlink|softlink) ;;
    *)
        echo "Error: Invalid move method '$move_method'" >&2
        show_help
        exit 1
        ;;
esac

# Set timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M")

# Determine destination
if [[ -n "$name" ]]; then
    destination="${name}-${timestamp}"
else
    first_file="${files[0]}"
    base=$(basename "$first_file")
    stem="${base%.*}"    # remove extension
    name="$stem"
    destination="${name}-${timestamp}"
fi

# Ensure destination exists
if [[ ! -d "$destination" ]]; then
    echo "Creating destination directory: $destination"
    mkdir -p "$destination"
fi

# Process files
for f in "${files[@]}"; do
    if [[ ! -e "$f" ]]; then
        echo "Warning: file '$f' does not exist, skipping." >&2
        continue
    fi

    case "$move_method" in
        mv)
            echo "Moving $f -> $destination/"
            mv "$f" "$destination/"
            ;;
        cp)
            echo "Copying $f -> $destination/"
            cp "$f" "$destination/"
            ;;
        hardlink)
            echo "Hardlinking $f -> $destination/"
            ln "$f" "$destination/"
            ;;
        softlink)
            echo "Symlinking $f -> $destination/"
            ln -s "$(realpath "$f")" "$destination/"
            ;;
    esac
done

echo "Done. Files are in: $destination"

