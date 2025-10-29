export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF
destinationDirectory="./hwc/library_templates"
if [ -d "./.apax" ]; then
  echo -e "${GREEN}Directory ./.apax exists.${NC}"

  # Ensure destination root exists
  mkdir -p "$destinationDirectory"

  # Find all 'assets' directories under .apax
  mapfile -t ASSETS_DIRS < <(find -L "./.apax" -type d -name 'assets')

  if [ ${#ASSETS_DIRS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No 'assets' directories found under ./.apax.${NC}"
    exit 0
  fi

  total=0
  for DIR in "${ASSETS_DIRS[@]}"; do
    # Find matching files recursively under each assets dir
    while IFS= read -r -d '' file; do
      # Compute path relative to the assets dir
      rel="${file#$DIR/}"                   # e.g., "sub/dir/file.hwl.json" or "file.hwl.yml"
      rel_dir="$(dirname "$rel")"           # e.g., "sub/dir" or "."
      target_dir="$destinationDirectory/$rel_dir"

      # Create target subdirectory if missing
      mkdir -p "$target_dir"

      # Copy the file, preserving relative subfolder structure
      cp -v "$file" "$target_dir/"

      echo -e "${GREEN}$file -> $target_dir${NC}"
      total=$((total + 1))
    done < <(find "$DIR" -type f \( -name "*.hwl.json" -o -name "*.hwl.yml" \) -print0)
  done

  if [ "$total" -gt 0 ]; then
    echo -e "${GREEN}$total file(s) copied to $destinationDirectory (subfolders preserved).${NC}"
  else
    echo -e "${YELLOW}No matching *.hwl.json or *.hwl.yml files found under any 'assets' directories.${NC}"
  fi

else
  echo -e "${RED}Directory ./.apax does not exist!${NC}"
fi
