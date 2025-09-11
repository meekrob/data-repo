#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob # for matching one-or-two characters 
# Use this script to advance data versions.
# It assumes the existence of files created by data-repo,
# including:
#  filelist
#  md5 sum
#  TODO: other processed output, such as fastqc

# version template tr
VERSION_DATE_FMT="+%Y-%m-%d-%H-%M"
VERSION_TEMPLATE_STR="v%02d-%s" # two-digit version number and date string
parse_version_str() { # USAGE: parse_version_str fileext
    vs="$1"
    V=${vs%%-*}
    numeric=${V#v}
    next_version=$((numeric + 1))
    timestamp=$(date ${VERSION_DATE_FMT})
    next_version_str=$(printf ${VERSION_TEMPLATE_STR} $next_version $timestamp)
    echo "$next_version_str"
}

# use with sed -E
SED_E_DELIM_PAT='s/.*(-v[0-9]+-).*/\1/' # group match outside of (-v03-)
SED_E_VERSION_NUMBER='s/.*-v([0-9]+)-.*/\1/' # group match inside like -v(03)-

get_version_delim() {
    echo $1 | sed -E $SED_E_DELIM_PAT
}

get_version_number() {
    echo $1 | sed -E $SED_E_VERSION_NUMBER
}

fname=$1
file_ext=.${fname#*.}
file_wo_ext=${fname%.$file_ext}
version_delim=$(get_version_delim $file_ext)
version_number=$(( $(get_version_number $file_ext) + 0))
ext_parts=(${file_ext/$version_delim/ })
echo "Filename: $file_wo_ext"
echo "Whole file extension: $file_ext"
echo "Parsed file extension: "
echo -e "\tFile ext: ${ext_parts[0]}"
echo -e "\tversion number:  $version_number"
echo -e "\tversion date:  ${ext_parts[1]}"
