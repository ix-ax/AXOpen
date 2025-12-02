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

# ---- Parse, sort, and transform using AWK ----
awk -v ns="$NAMESPACE" '
BEGIN {
    in_block = 0;
}
{
    line = $0
    gsub(/\r/, "", line)

    # Detect start/end of the relevant block
    if (line ~ /VAR_GLOBAL CONSTANT/) { in_block = 1; next }
    if (line ~ /END_VAR/) { in_block = 0; next }

    if (!in_block) next

    # We are inside the constant block
    # Expected format:  NAME : UINT := UINT#123;
    if (match(line, /^[[:space:]]*([A-Za-z0-9_]+)[[:space:]]*:[[:space:]]*UINT[[:space:]]*:=[[:space:]]*UINT#([0-9]+)[[:space:]]*;/, m)) {
        name = m[1]
        val  = m[2]
        items[name] = val
    }
}

END {
    print "NAMESPACE " ns
    print "    TYPE"
    print "        HwIdentifiers : UINT"
    print "        ("

    n = asorti(items, sorted, "@val_num_asc")   # numeric ascending sort

    if (n == 0) {
        # No items found → output NONE only
        print "            NONE := UINT#0"
    } else {
        # Print sorted items without final trailing comma
        for (i = 1; i <= n; i++) {
            key = sorted[i]
            val = items[key]

            last = (i == n) ? "" : ","
            print "            " key " := UINT#" val last
        }
    }

    print "        );"
    print "    END_TYPE"
    print "END_NAMESPACE"
}
' "$input_file" > "$output_file"

echo -e "${GREEN}Generation complete. Output written to $output_file${NC}"