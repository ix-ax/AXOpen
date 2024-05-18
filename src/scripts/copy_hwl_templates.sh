if [ -d "../ctrl/assets" ]; then
  echo "Directory "../ctrl/assets" exists!!!"
  if ! [[ -d "./hwc" ]]; then
    echo "Directory "./hwc" does not exist!!!"
    mkdir -p "./hwc"
  fi
  sourceDirectory="../ctrl/assets"
  destinationDirectory="./hwc"
  fileMask="*.hwl.json"
  files=($sourceDirectory/$fileMask)
  if [ ${#files[@]} -gt 0 ] && [ "${files[0]}" != "$sourceDirectory/$fileMask" ]; then
    echo " ${#files[@]}  files is going to be copied to $destinationDirectory."
    cp $sourceDirectory/$fileMask $destinationDirectory
    echo " ${#files[@]} files copied to $destinationDirectory."
  else
    echo "No files matching the pattern '$fileMask' were found in '$sourceDirectory'."
  fi
else
  echo "Directory "../ctrl/assets" does not exist!!!"
fi