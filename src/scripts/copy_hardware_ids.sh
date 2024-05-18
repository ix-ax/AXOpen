if ! [[ -d "./hwc" ]]; then
  echo "Directory ".\hwc" does not exist!!!"
  exit 1
fi
input_file=SystemConstants/$PLC_NAME"_HwIdentifiers.st"
if ! [[ -e $input_file ]]; then
  echo "File $input_file does not exist!!!"
  exit 1
fi
output_dir=src/IO/$PLC_NAME
if ! [[ -d $output_dir ]]; then
  echo "Directory $output_dir does not exist!!!"
  mkdir -p $output_dir
fi
output_file="$output_dir/HwIdentifiers.st"
lines_to_replace=("CONFIGURATION HardwareIDs" "VAR_GLOBAL CONSTANT" "END_VAR" "END_CONFIGURATION")
old_substrings=(": UINT := UINT" ";")
new_substrings=(":=	WORD" ",")
echo "TYPE" > "$output_file"
echo "    HwIdentifiers : WORD" >> "$output_file"
echo "    (" >> "$output_file"
while IFS= read -r line; do
  copy_this_line=true
  for line_to_replace in "${lines_to_replace[@]}"; do
    if grep -qF "$line_to_replace" <<< "$line"; then
      copy_this_line=false
      break
    fi
  done
  if $copy_this_line; then
    modified_line="$line"
    for ((i=0; i<${#old_substrings[@]}; i++)); do
      old_substring="${old_substrings[i]}"
      new_substring="${new_substrings[i]}"
      modified_line="${modified_line//$old_substring/$new_substring}"
    done
    echo "$modified_line" >> "$output_file"
  fi
done < "$input_file"
echo "        NONE := WORD#0" >> "$output_file"
echo "    );" >> "$output_file"
echo "END_TYPE" >> "$output_file"