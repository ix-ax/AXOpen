export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color

destinationDirectory="./gsd/source"
fileMask='GSDML*.xml'   # case-insensitive via find -iname

if [ -d "./.apax" ]; then
  echo -e "${GREEN}Directory ./.apax exists!!!${NC}"

  # Ensure destination root exists
  if [ ! -d "$destinationDirectory" ]; then
    echo -e "${YELLOW}Directory $destinationDirectory does not exist!!!${NC}"
    mkdir -p "$destinationDirectory"
  fi

  # Find all 'assets' directories under .apax
  mapfile -t ASSETS_DIRS < <(find -L "./.apax" -type d -name 'assets')

  if [ ${#ASSETS_DIRS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No 'assets' directories found under ./.apax.${NC}"
  fi

  total=0
  for DIR in "${ASSETS_DIRS[@]}"; do
    # Find matching files recursively and copy to flat destination dir
    while IFS= read -r -d '' file; do
      base="$(basename "$file")"
      # Optional: warn on name collisions (we overwrite by default)
      if [ -f "$destinationDirectory/$base" ]; then
        echo -e "${YELLOW}Warning: overwriting existing $base in $destinationDirectory${NC}"
      fi

      cp -v -f "$file" "$destinationDirectory/$base"
      echo -e "${GREEN}$file -> $destinationDirectory/$base${NC}"
      total=$((total + 1))
    done < <(find "$DIR" -type f -iname "$fileMask" -print0)
  done

  if [ "$total" -gt 0 ]; then
    echo -e "${GREEN}$total file(s) copied to $destinationDirectory (flat layout).${NC}"
  else
    echo -e "${YELLOW}No files matching '$fileMask' found under any 'assets' directories.${NC}"
  fi

else
  echo -e "${RED}Directory ./.apax does not exist!!!${NC}"
fi

# Ensure destination root exists
if [ ! -d "$destinationDirectory" ]; then
  echo -e "${YELLOW}Directory $destinationDirectory does not exist!!!${NC}"
  mkdir -p "$destinationDirectory"
fi

gsdDirectory="./gsd"

# Install from destination if anything is present (could include existing files)
dest_count=$(find "$gsdDirectory" -type f -iname "$fileMask" | wc -l | tr -d ' ')
if [ "$dest_count" -gt 0 ]; then
  echo -e "${GREEN}$dest_count file(s) will be installed from $gsdDirectory.${NC}"
  if ! apax hwc install-gsd --input "$gsdDirectory"; then
    printf "${RED}The installation of the gsdml files finished with an error!${NC}\n"
    printf "${RED}Please check the details above.${NC}\n"
    exit 1
  fi
  echo -e "${GREEN}$dest_count file(s) installed.${NC}"
else
  echo -e "${YELLOW}No files matching '$fileMask' were found in '$gsdDirectory'.${NC}"
fi