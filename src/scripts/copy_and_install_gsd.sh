if [ -d "../ctrl/assets" ]; then
  echo "Directory "../ctrl/assets" exists!!!"
  if ! [[ -d "./gsd/source" ]]; then
    echo "Directory "./gsd/source" does not exist!!!"
    mkdir -p "./gsd/source"
  fi
  sourceDirectory="../ctrl/assets"
  destinationDirectory="./gsd/source"
  fileMask="[gG][sS][dD][mM][lL]*.xml"
  files=($sourceDirectory/$fileMask)
  if [ ${#files[@]} -gt 0 ] && [ "${files[0]}" != "$sourceDirectory/$fileMask" ]; then
    echo " ${#files[@]}  files is going to be copied to $destinationDirectory."
    cp $sourceDirectory/$fileMask $destinationDirectory
    echo " ${#files[@]} files copied to $destinationDirectory."
  else
      echo "No files matching the pattern '$fileMask' were found in '$sourceDirectory'."
  fi
  files=($destinationDirectory/$fileMask)
  if [ ${#files[@]} -gt 0 ] && [ "${files[0]}" != "$destinationDirectory/$fileMask" ]; then
    echo " ${#files[@]} files is going to be installed."
    apax hwc install-gsd --input  $destinationDirectory
    echo " ${#files[@]} files installed"
  else
      echo "No files matching the pattern '$fileMask' were found in '$destinationDirectory'."
  fi
else
  echo "Directory "../ctrl/assets" does not exist!!!"
fi