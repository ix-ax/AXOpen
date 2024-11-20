if [ -d "./.apax" ]; then
  echo "Directory ".apax" exists!!!"
  if ! [[ -d "./hwc" ]]; then
    echo "Directory "./hwc" does not exist!!!"
    mkdir -p "./hwc"
  fi
  
  ASSETS_DIRS=$(find -L "./.apax" -type d -name 'assets')

  for DIR in $ASSETS_DIRS; do      
    sourceDirectory="$DIR"
    destinationDirectory="./hwc"
    fileMask="*.hwl.json"      
    # files=($sourceDirectory/$fileMask)
    files=($(find "$sourceDirectory" -maxdepth 1 \( -name "*.hwl.json" -o -name "*.hwl.yml" \)))
    # if [ ${#files[@]} -gt 0 ] && [ "${files[0]}" != "$sourceDirectory/$fileMask" ]; then
	if [ ${#files[@]} -gt 0 ]; then
      echo "${#files[@]} files are going to be copied to $destinationDirectory."
      # cp -v "${files[@]}" "$destinationDirectory"
	  for file in "${files[@]}"; do
		cp -v "$file" "$destinationDirectory"
		echo "$file file copied to $destinationDirectory."
	  done
      echo "${#files[@]} files copied to $destinationDirectory."
    else
      echo "No files matching the pattern '$fileMask' were found in '$sourceDirectory'."
    fi
  done

  
else
  echo "Directory "../ctrl/assets" does not exist!!!"
fi