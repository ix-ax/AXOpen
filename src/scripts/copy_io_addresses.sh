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
output_file="$output_dir/IoAddresses.st"
echo "  " > "$output_file"
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
    echo "$modified_line" >> "$output_file"
done < "$input_file"
