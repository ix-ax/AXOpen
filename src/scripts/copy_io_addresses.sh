if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <NAMESPACE> <PLC_NAME>"
    exit 1
fi
NAMESPACE=$1
if [ -z $NAMESPACE ]; then
    echo "The NAMESPACE could not be an empty string."
    exit 1
fi
PLC_NAME=$2
if [ -z $PLC_NAME ]; then
    echo "The PLC_NAME could not be an empty string."
    exit 1
fi
if ! [[ -d "./hwc" ]]; then
  echo "Directory ".\hwc" does not exist!!!"
  exit 1
fi
input_file=SystemConstants/$PLC_NAME"_IoAddresses.st"
if ! [[ -e $input_file ]]; then
  echo "File $input_file does not exist!!!"
  exit 1
fi
output_dir=src/IO/$PLC_NAME
if ! [[ -d $output_dir ]]; then
  echo "Directory $output_dir does not exist!!!"
  mkdir -p $output_dir
fi
output_file_inputs="$output_dir/Inputs.st"
output_file_outputs="$output_dir/Outputs.st"
echo "NAMESPACE ${NAMESPACE}" > "$output_file_inputs"
echo "NAMESPACE ${NAMESPACE}" > "$output_file_outputs"
echo "    TYPE" >> "$output_file_inputs"
echo "    TYPE" >> "$output_file_outputs"
echo "        {S7.extern=ReadWrite}" >> "$output_file_inputs"
echo "        {S7.extern=ReadWrite}" >> "$output_file_outputs"
echo "        {#ix-attr:[Container(Layout.Wrap)]}" >> "$output_file_inputs"
echo "        {#ix-attr:[Container(Layout.Wrap)]}" >> "$output_file_outputs"
echo "        Inputs : STRUCT" >> "$output_file_inputs"
echo "        Outputs : STRUCT" >> "$output_file_outputs"

while IFS= read -r line; do
	modified_line="$line"
	# Check if the variable starts with a letter
	# Find the position of the first non-whitespace character
	first_non_white_pos=$(expr match "$modified_line" '^[[:space:]]*')
	
	# Extract the first non-whitespace character
	first_char="${modified_line:$first_non_white_pos:1}"
	
	# Check if the string contains only whitespace
	if [[ "$first_non_white_pos" -lt "${#modified_line}" ]]; then
	  	# Check if the first non-whitespace character is not a letter
	  	if [[ ! "$first_char" =~ [a-zA-Z] ]]; then
	  		# Split the string into two parts: before and after the first non-whitespace character
	  		before_first_char="${modified_line:0:$first_non_white_pos}"
	  		after_first_char="${modified_line:$first_non_white_pos}"
	  		
	  		# Avoid adding an extra underscore if the first character is already an underscore
	  		if [[ "$first_char" != "_" ]]; then
	  			modified_line="${before_first_char}_${after_first_char}"
	  		fi
	  	fi
	fi
	
    # Check if the modified_line contains the substring "_InputAddress"
    if [[ $modified_line == *"_InputAddress"* ]]; then
		# Extract the first word without "_InputAddress"
		variable_name=$(echo "$line" | awk '{print $1}' | sed 's/_InputAddress//')
		
		# Extract the number from the substring after % and before :
		address_offset=$(echo "$line" | awk -F'%' '{print $2}' | awk -F':' '{print $1}' | grep -o '[0-9]\+')
		
		# Extract the substring from : to ;, excluding : and ;
		variable_type=$(echo "$line" | awk -F':' '{print $2}' | awk -F';' '{print $1}')
		
		# Output the variables
		echo "            ${variable_name} AT %B${address_offset}: ${variable_type};" >> "$output_file_inputs"
	fi

    # Check if the modified_line contains the substring "_OutputAddress"
    if [[ $modified_line == *"_OutputAddress"* ]]; then
		# Extract the first word without "_OutputAddress"
		variable_name=$(echo "$line" | awk '{print $1}' | sed 's/_OutputAddress//')
		
		# Extract the number from the substring after % and before :
		address_offset=$(echo "$line" | awk -F'%' '{print $2}' | awk -F':' '{print $1}' | grep -o '[0-9]\+')
		
		# Extract the substring from : to ;, excluding : and ;
		variable_type=$(echo "$line" | awk -F':' '{print $2}' | awk -F';' '{print $1}')
		
		# Output the variables
		echo "            ${variable_name} AT %B${address_offset}: ${variable_type};" >> "$output_file_outputs"
	fi
done < "$input_file"
echo "        END_STRUCT;" >> "$output_file_inputs"
echo "        END_STRUCT;" >> "$output_file_outputs"
echo "    END_TYPE" >> "$output_file_inputs"
echo "    END_TYPE" >> "$output_file_outputs"
echo "END_NAMESPACE" >> "$output_file_inputs"
echo "END_NAMESPACE" >> "$output_file_outputs"
