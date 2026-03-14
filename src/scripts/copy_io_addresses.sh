#!/bin/bash

# ---- Colors ----
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color + CRLF

# ---- Argument Validation ----
if [ "$#" -ne 2 ]; then
    printf "${RED}Usage: $0 <NAMESPACE> <PLC_NAME>.${NC}"
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
# ---- Paths ----
input_file="SystemConstants/${PLC_NAME}_IoAddresses.st"
output_dir="src/IO"
output_file_inputs="$output_dir/Inputs.st"
output_file_outputs="$output_dir/Outputs.st"
output_file_structures="$output_dir/IoStructures.st"

if ! [[ -e "$input_file" ]]; then
    printf "${RED}File $input_file does not exist!!!${NC}"
    exit 1
fi

hwcv=$(apax hwc --version)
echo "hwc version used: '$hwcv'."

# Condition 1: all versions below 3.4.0
if [[ "$(printf '%s\n' "$hwcv" "3.4.0" | sort -V | head -n1)" == "$hwcv" && "$hwcv" != "3.4.0" ]]; then
	mkdir -p "$output_dir"
	# --- Init outputs ------------------------------------------------------------
	: > "$output_file_inputs"
	: > "$output_file_outputs"
	: > "$output_file_structures"
	# ---- AWK Processing ----
	awk -v ns="$NAMESPACE" '
	BEGIN {
		hasInputs = 0
		hasOutputs = 0

		print "NAMESPACE " ns "\n    TYPE\n        {S7.extern=ReadWrite}\n        {#ix-attr:[Container(Layout.Wrap)]}\n        Inputs : STRUCT" > "'"$output_file_inputs"'"
		print "NAMESPACE " ns "\n    TYPE\n        {S7.extern=ReadWrite}\n        {#ix-attr:[Container(Layout.Wrap)]}\n        Outputs : STRUCT" > "'"$output_file_outputs"'"
	}
	{
		line = $0
		gsub(/\r/, "", line)

		# Prepend underscore if first char is invalid
		match(line, /^[[:space:]]*/)
		prefix = substr(line, 1, RLENGTH)
		rest = substr(line, RLENGTH+1)
		first = substr(rest, 1, 1)
		if (first !~ /[a-zA-Z_]/ && first != "") {
			rest = "_" rest
		}
		line = prefix rest

		# INPUT processing
		if (line ~ /_InputAddress/) {
			name = $1
			sub(/_InputAddress/, "", name)  # remove only first occurrence
			match(line, /%[A-Z]+([0-9]*):/, addr)
			match(line, /:[[:space:]]*([^;]+);/, typ)
			if (name && addr[1] != "" && typ[1]) {
				printf "            %s AT %%B%s:  %s;\n", name, addr[1], typ[1] >> "'"$output_file_inputs"'"
				hasInputs = 1
			}
		}

		# OUTPUT processing
		if (line ~ /_OutputAddress/) {
			name = $1
			sub(/_OutputAddress/, "", name)  # remove only first occurrence
			match(line, /%[A-Z]+([0-9]*):/, addr)
			match(line, /:[[:space:]]*([^;]+);/, typ)
			if (name && addr[1] != "" && typ[1]) {
				printf "            %s AT %%B%s:  %s;\n", name, addr[1], typ[1] >> "'"$output_file_outputs"'"
				hasOutputs = 1
			}
		}
	}
	END {
		if (!hasInputs)
			print "            noInputsFoundInTheHwConfig AT %B0:  BYTE;" >> "'"$output_file_inputs"'"
		if (!hasOutputs)
			print "            noOutputsFoundInTheHwConfig AT %B0:  BYTE;" >> "'"$output_file_outputs"'"

		print "        END_STRUCT;\n    END_TYPE\nEND_NAMESPACE" >> "'"$output_file_inputs"'"
		print "        END_STRUCT;\n    END_TYPE\nEND_NAMESPACE" >> "'"$output_file_outputs"'"
	}
	' "$input_file"

	echo -e "${GREEN}Done. Files written to $output_dir${NC}"
else
	# echo "input_file: $input_file"
	# echo "output_dir: $output_dir"
	# echo "output_file_inputs: $output_file_inputs"
	# echo "output_file_outputs: $output_file_outputs"
	# echo "output_file_structures: $output_file_structures"
	# echo "NAMESPACE: $NAMESPACE"
	scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	copy_io_addresses_hwc_3_4_0="$scriptDir/copy_io_addresses_hwc_3_4_0.ps1"

	powershell.exe -File "$copy_io_addresses_hwc_3_4_0" \
										  -input_file "$input_file" \
										  -output_dir "$output_dir" \
										  -output_file_inputs "$output_file_inputs" \
										  -output_file_outputs "$output_file_outputs" \
										  -output_file_structures "$output_file_structures" \
										  -NAMESPACE "$NAMESPACE"
	exitCode=$?  
	echo "exitCode: $exitCode"
fi
dos2unix -r src/IO/*
