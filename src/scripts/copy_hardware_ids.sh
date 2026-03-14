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
dos2unix SystemConstants/*
dos2unix -r hwc/hwc.gen/*
input_file="SystemConstants/${PLC_NAME}_HwIdentifiers.st"
output_dir="src/IO"
output_file1="${output_dir}/HwIdentifiers.st"
output_file2="${output_dir}/HwIdentifierList.st"

if ! [[ -e "$input_file" ]]; then
    printf "${RED}File $input_file does not exist!!!${NC}"
    exit 1
fi

mkdir -p "$output_dir"


# ============================================================
#  AWK: read constants once, then output two files:
#    1) HwIdentifiers.st (existing behavior)
#    2) HwIDs.st (new — simple constant declarations)
# ============================================================
awk -v ns="$NAMESPACE" -v OUT1="$output_file1" -v OUT2="$output_file2" '
BEGIN {
    in_block = 0;
}
{
    line = $0
    gsub(/\r/, "", line)

    # Detect block
    if (line ~ /VAR_GLOBAL CONSTANT/) { in_block = 1; next }
    if (line ~ /END_VAR/)             { in_block = 0; next }

    if (!in_block) next

    # Expected format:  NAME : UINT := UINT#123;
    if (match(line, /^[[:space:]]*([A-Za-z0-9_]+)[[:space:]]*:[[:space:]]*UINT[[:space:]]*:=[[:space:]]*UINT#([0-9]+)[[:space:]]*;/, m)) {
        name = m[1]
        val  = m[2]
        items[name] = val
    }
}

END {
    ####################################################################
    #  ------- 1) Generate HwIdentifiers.st (ENUM style) --------------
    ####################################################################
    out = ""
    out = out "NAMESPACE " ns "\n"
    out = out "    TYPE\n"
    out = out "        HwIdentifiers : UINT\n"
    out = out "        (\n"

    n = asorti(items, sorted, "@val_num_asc")

    if (n == 0) {
        out = out "            NONE := UINT#0\n"
    } else {
        for (i = 1; i <= n; i++) {
            key = sorted[i]
            val = items[key]
            last = (i == n ? "" : ",")
            out = out "            " key " := UINT#" val last "\n"
        }
    }

    out = out "        );\n"
    out = out "    END_TYPE\n"
    out = out "END_NAMESPACE\n"

    # Write file 1
    print out > OUT1


    ####################################################################
    #  ------- 2) Generate HwIdentifierList.st ----------------
    ####################################################################
    out2 = ""
    out2 = out2 "NAMESPACE " ns "\n"
    out2 = out2 "    TYPE HwIdentifierList : ARRAY[0.." n - 1 "] OF UINT :=\n"
    out2 = out2 "            [\n"

    for (i = 1; i <= n; i++) {
        val = items[sorted[i]]
        last = (i == n ? "" : ",")
        out2 = out2 "                UINT#" val last "\n"
    }


    out2 = out2 "    ];\n"
    out2 = out2 "END_TYPE\n"
    out2 = out2 "END_NAMESPACE\n"

    # Write file 2
    print out2 > OUT2
}
' "$input_file"

dos2unix -r src/IO/*
echo -e "${GREEN}Generation complete.${NC}"
echo -e "${GREEN} - ${output_file1}${NC}"
echo -e "${GREEN} - ${output_file2}${NC}"
