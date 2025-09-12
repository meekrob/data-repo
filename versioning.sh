#!/usr/bin/env bash
set -euo pipefail

# Use this script to advance data versions.
# It assumes the existence of files created by data-repo,
# including:
#  filelist
#  md5 sum
#  TODO: other processed output, such as fastqc

# version template tr
VERSION_DATE_FMT="+%Y-%m-%d-%H-%M"
TIMESTAMP=$(date ${VERSION_DATE_FMT})
VERSION_TEMPLATE_STR="v%02d-%s" # two-digit version number and date string

# extended patterns to extract the version number
SED_E_DELIM_PAT='s/.*(-v[0-9]+-).*/\1/' # group match outside of (-v03-)
SED_E_VERSION_NUMBER='s/.*-v([0-9]+)-.*/\1/' # group match inside like -v(03)-

get_version_delim() {
    echo $1 | sed -E $SED_E_DELIM_PAT
}

get_version_number() {
    echo $1 | sed -E $SED_E_VERSION_NUMBER
}

get_file_mod_time() {
    date -d "@$(stat -c %Y $1)" $VERSION_DATE_FMT
}

fname=$1
file_ext=.${fname#*.}
file_wo_ext=${fname%.$file_ext}
version_delim=$(get_version_delim $file_ext) # a non-match returns the same string (Version not found)

if [ "$file_ext" = "$version_delim" ]
then
    # file doesn't have version string in name yet
    # assume version 1
    base=$fname
    next_version=1
else
    version_number=$(( $(get_version_number $file_ext) + 0))
    ext_parts=(${file_ext/$version_delim/ })
    echo "Filename: $file_wo_ext"
    echo "Whole file extension: $file_ext"
    echo "Parsed file extension: "
    echo -e "\tFile ext: ${ext_parts[0]}"
    echo -e "\tversion number:  $version_number"
    echo -e "\tversion date:  ${ext_parts[1]}"

    file_parts=(${fname/$version_delim/ })
    next_version=$((version_number + 1))
    base=${file_parts[0]}

fi
FILE_MOD_TIME=$(get_file_mod_time $fname)
new_filename=$base-$(printf "$VERSION_TEMPLATE_STR" $next_version $FILE_MOD_TIME)
echo "Next version filename: $new_filename"


