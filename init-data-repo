#!/usr/bin/env bash
#
# Usage: datadir [options] file[s]
#

set -euo pipefail

log_command="$@"

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

# Determine destination directory
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

# Initialize file list
filelist="${destination}/${name}.filelist.txt"
echo -e "Filename\tSize\tCreationDate" > "$filelist"

# Process files
for f in "${files[@]}"; do
    if [[ ! -e "$f" ]]; then
        echo "Warning: file '$f' does not exist, skipping." >&2
        continue
    fi

    case "$move_method" in
        mv)
            mv "$f" "$destination/"
            ;;
        cp)
            cp "$f" "$destination/"
            ;;
        hardlink)
            ln "$f" "$destination/"
            ;;
        softlink)
            ln -s "$(realpath "$f")" "$destination/"
            ;;
    esac

    # Determine path in destination
    destfile="$destination/$(basename "$f")"

    # Get human-readable size
    if [[ -f "$destfile" || -L "$destfile" ]]; then
        size=$(du -h "$destfile" | cut -f1)
        # Use the file's creation/modification date
        cdate=$(stat -c "%y" "$destfile" 2>/dev/null || stat -f "%Sm" "$destfile")  # Linux or Mac
        echo -e "$(basename "$f")\t$size\t$cdate" >> "$filelist"
    fi
done

echo "Done. Files are in: $destination"
echo "File list created: $filelist"

# variables for use in other scripts
echo "NAME=$name" >> repo.rc
DEST_ABS=$(cd "$destination" && pwd)
FILELIST_ABS=$(cd "$(dirname "$filelist")" && echo "$(pwd)/$(basename "$filelist")")
echo "DEST_ABSPATH=\"$DEST_ABS\"" >> repo.rc
echo "FILELIST_ABSPATH=\"$FILELIST_ABS\"" >> repo.rc

# time to write utility scripts
SLURM_MD5_ARRAY_PATH=scripts/slurm-md5-array
mkdir -p $SLURM_MD5_ARRAY_PATH


# create the md5 launch script
md5_filename=${FILELIST_ABS/.filelist.txt/.filelist.md5}
cat << "EOF" > "$SLURM_MD5_ARRAY_PATH/launch-pipeline.sh"
#!/usr/bin/env bash
set -euo pipefail
outfile=$md5_filename
nfiles=\$(grep -v Filename $filelist | wc -l)
filelist=\$(grep -v Filename $filelist | cut -f 1)
main_jid=\$(sbatch --parsable --array=1-\$nfiles scripts/slurm-md5-array/md5sum-array.sbatch \$filelist)
sbatch --dependency=afterok:\$main_jid scripts/slurm-md5-array/concat-md5.sbatch \$outfile
EOF 

# add (or create) README 
echo "$(date): Data repo $name initialized with:" >> README
echo "$log_command" >> README
