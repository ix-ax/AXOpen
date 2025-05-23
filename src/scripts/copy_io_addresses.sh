export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

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

input_file="SystemConstants/${PLC_NAME}_IoAddresses.st"
output_dir="src/IO"
output_file_inputs="$output_dir/Inputs.st"
output_file_outputs="$output_dir/Outputs.st"

if ! [[ -e "$input_file" ]]; then
    printf "${RED}File $input_file does not exist!!!${NC}"
    exit 1
fi

mkdir -p "$output_dir"

noInputsFoundInTheHwConfig=1
noOutputsFoundInTheHwConfig=1

# Base content
inputs_content="NAMESPACE ${NAMESPACE}
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT"
outputs_content="NAMESPACE ${NAMESPACE}
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT"

# Read the entire file into a single variable
file_content=$(<"$input_file")

# Process all lines
while IFS= read -r line; do
    modified_line="$line"
    first_non_white_pos=$(expr match "$modified_line" '^[[:space:]]*')
    first_char="${modified_line:$first_non_white_pos:1}"

    if [[ "$first_non_white_pos" -lt "${#modified_line}" && ! "$first_char" =~ [a-zA-Z] ]]; then
        before_first_char="${modified_line:0:$first_non_white_pos}"
        after_first_char="${modified_line:$first_non_white_pos}"
        if [[ "$first_char" != "_" ]]; then
            modified_line="${before_first_char}_${after_first_char}"
        fi
    fi

    if [[ $modified_line == *"_InputAddress"* ]]; then
        variable_name=$(echo "$modified_line" | awk '{print $1}' | sed 's/_InputAddress//')
        address_offset=$(echo "$modified_line" | awk -F'%' '{print $2}' | awk -F':' '{print $1}' | grep -o '[0-9]\+')
        variable_type=$(echo "$modified_line" | awk -F':' '{print $2}' | awk -F';' '{print $1}')
        noInputsFoundInTheHwConfig=0
        inputs_content+="
            ${variable_name} AT %B${address_offset}: ${variable_type};"
    fi

    if [[ $modified_line == *"_OutputAddress"* ]]; then
        variable_name=$(echo "$modified_line" | awk '{print $1}' | sed 's/_OutputAddress//')
        address_offset=$(echo "$modified_line" | awk -F'%' '{print $2}' | awk -F':' '{print $1}' | grep -o '[0-9]\+')
        variable_type=$(echo "$modified_line" | awk -F':' '{print $2}' | awk -F';' '{print $1}')
        noOutputsFoundInTheHwConfig=0
        outputs_content+="
            ${variable_name} AT %B${address_offset}: ${variable_type};"
    fi
done <<< "$file_content"

# Add fallback if no addresses found
if [ $noInputsFoundInTheHwConfig -eq 1 ]; then
    inputs_content+="
            noInputsFoundInTheHwConfig AT %B0: BYTE;"
fi
if [ $noOutputsFoundInTheHwConfig -eq 1 ]; then
    outputs_content+="
            noOutputsFoundInTheHwConfig AT %B0: BYTE;"
fi

# Footer
inputs_content+="
        END_STRUCT;
    END_TYPE
END_NAMESPACE"
outputs_content+="
        END_STRUCT;
    END_TYPE
END_NAMESPACE"

# Write all content at once
echo "$inputs_content" > "$output_file_inputs"
echo "$outputs_content" > "$output_file_outputs"
