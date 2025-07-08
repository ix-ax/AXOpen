#!/bin/bash

# ---- Colors ----
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

# ---- Argument validation ----
if [ "$#" -ne 2 ]; then
    printf "${RED}Usage: $0 <NAMESPACE> <PLC_NAME>${NC}"
    exit 1
fi

NAMESPACE=$1
PLC_NAME=$2

if [ -z "$NAMESPACE" ]; then
    printf "${RED}The NAMESPACE could not be an empty string.${NC}"
    exit 1
fi

if [ -z "$PLC_NAME" ]; then
    printf "${RED}The PLC_NAME could not be an empty string.${NC}"
    exit 1
fi

if ! [[ -d "./hwc" ]]; then
    printf "${RED}Directory \"./hwc\" does not exist!!!${NC}"
    exit 1
fi

input_file="SystemConstants/${PLC_NAME}_HwIdentifiers.st"
output_dir="src/IO"
output_file="${output_dir}/HwIdentifiers.st"

if ! [[ -e "$input_file" ]]; then
    printf "${RED}File $input_file does not exist!!!${NC}"
    exit 1
fi

mkdir -p "$output_dir"

# ---- Inline AWK transformation ----
awk -v ns="$NAMESPACE" "
BEGIN {
    print \"NAMESPACE \" ns
    print \"    TYPE\"
    print \"        HwIdentifiers : WORD\"
    print \"        (\"
}
{
    line = \$0
    gsub(/\\r/, \"\", line)

    if (line ~ /CONFIGURATION HardwareIDs|VAR_GLOBAL CONSTANT|END_VAR|END_CONFIGURATION/) next

    gsub(/:_/, \"__\", line)
    gsub(/: UINT := UINT/, \":=\\tWORD\", line)
    gsub(/;/, \",\", line)

    match(line, /^[[:space:]]*/)
    prefix = substr(line, 1, RLENGTH)
    rest = substr(line, RLENGTH + 1)
    first = substr(rest, 1, 1)
    if (first !~ /[a-zA-Z_]/ && first != \"\") {
        rest = \"_\" rest
    }

    print \"    \" prefix rest
}
END {
    print \"            NONE := WORD#0\"
    print \"        );\"
    print \"    END_TYPE\"
    print \"END_NAMESPACE\"
}
" "$input_file" > "$output_file"

echo -e "${GREEN}Generation complete. Output written to $output_file${NC}"
