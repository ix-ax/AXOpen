export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <NAMESPACE>"
    exit 1
fi

NAMESPACE=$1
if [ -z $NAMESPACE ]; then
	printf "${RED}The NAMESPACE could not be an empty string.${NC}"
    exit 1
fi
NAMESPACE_AFTER_SLASH=${NAMESPACE#*/}

# Convert to PascalCase (capitalize first letter of each segment)
IFS='.' read -ra PARTS <<< "$NAMESPACE_AFTER_SLASH"
COMPONENT_NAMESPACE=""
for part in "${PARTS[@]}"; do
    # Special case for axopen or Axopen
    if [[ "${part,,}" == "axopen" ]]; then
        COMPONENT_NAMESPACE+="AXOpen."
    else
        # Capitalize first letter, preserve rest
        COMPONENT_NAMESPACE+=$(tr '[:lower:]' '[:upper:]' <<< "${part:0:1}")${part:1}.
    fi
done
# Step 3: Remove trailing dot
COMPONENT_NAMESPACE=${COMPONENT_NAMESPACE%.}
printf "${GREEN}The NAMESPACE is: $COMPONENT_NAMESPACE.${NC}"

if [ -z "$2" ]; then
  while [[ ! "$component_name" =~ ^[A-Z][a-zA-Z0-9_]*$ ]]; do
    echo "Enter the component name (mandatory):"
    echo "ATTENTION: The name must start with an upper-case letter, no spaces, and no special characters."
    read component_name
	printf "${GREEN}The Component name is: $component_name.${NC}"
  done
fi

# Set your variables here
plc_src_loc_rel="..\..\template.axolibrary\ctrl\src\TemplateComponent"
plc_src_loc_abs="$(cd "$(dirname "$plc_src_loc_rel")" && pwd)/$(basename "$plc_src_loc_rel")"
plc_dest_loc_rel="src"
plc_dest_loc_abs="$(cd "$(dirname "$plc_dest_loc_rel")" && pwd)/$(basename "$plc_dest_loc_rel")"
plc_dest_loc_abs_final="$plc_dest_loc_abs/$component_name"
dotnet_src_loc_rel="..\..\template.axolibrary\src\projname\TemplateComponent"
dotnet_src_loc_abs="$(cd "$(dirname "$dotnet_src_loc_rel")" && pwd)/$(basename "$dotnet_src_loc_rel")"
dotnet_dest_loc="..\src"
dotnet_dest_loc_rel="$dotnet_dest_loc/$COMPONENT_NAMESPACE"
dotnet_dest_loc_abs="$(cd "$(dirname "$dotnet_dest_loc_rel")" && pwd)/$(basename "$dotnet_dest_loc_rel")"
dotnet_dest_loc_abs_final="$dotnet_dest_loc_abs/$component_name"

printf "${GREEN}The plc source dir is: $plc_src_loc_abs.${NC}"
printf "${GREEN}The plc dest dir is: $plc_dest_loc_abs.${NC}"
printf "${GREEN}The plc final dest dir is: $plc_dest_loc_abs_final.${NC}"
printf "${GREEN}The dotnet source dir is: $dotnet_src_loc_abs.${NC}"
printf "${GREEN}The dotnet dest dir is: $dotnet_dest_loc_abs.${NC}"
printf "${GREEN}The dotnet final dest dir is: $dotnet_dest_loc_abs_final.${NC}"

template_name="TemplateComponent"
TEMPLATE_NAMESPACE="Template.Axolibrary"

###############PLC#######################
# Check if plc_src_loc_abs exists
if [ ! -d "$plc_src_loc_abs" ]; then
    echo "Source directory '$plc_src_loc_abs' does not exist. Exiting."
    exit 1
fi

# Check if plc_dest_loc_abs_final already exists
if [ -e "$plc_dest_loc_abs_final" ]; then
    echo "Destination directory '$plc_dest_loc_abs_final' already exists. Exiting."
    exit 1
fi

# Copy plc_src_loc_abs to plc_dest_loc_abs
cp -r "$plc_src_loc_abs" "$plc_dest_loc_abs"

# Change to destination directory
cd "$plc_dest_loc_abs" || exit 1

# Step 1: Rename directories
find . -depth -type d -name "*$template_name*" | while read -r dir; do
    newdir=$(echo "$dir" | sed "s/$template_name/$component_name/g")
    mv "$dir" "$newdir"
done

# Step 2: Rename files
find . -depth -type f -name "*$template_name*" | while read -r file; do
    newfile=$(echo "$file" | sed "s/$template_name/$component_name/g")
    mv "$file" "$newfile"
done

# Step 3: Replace content inside files
# Only process text files (heuristically using 'file' command)
find . -type f | while read -r file; do
    if file "$file" | grep -qE 'text'; then
        sed -i "s/$template_name/$component_name/g" "$file"
        sed -i "s/$TEMPLATE_NAMESPACE/$COMPONENT_NAMESPACE/g" "$file"
    fi
done

echo "PLC part copied, all replacements done successfully."

###############DOTNET#######################
# Check if dotnet_src_loc_abs exists
if [ ! -d "$dotnet_src_loc_abs" ]; then
    echo "Source directory '$dotnet_src_loc_abs' does not exist. Exiting."
    exit 1
fi

# Check if dotnet_dest_loc_abs_final already exists
if [ -e "$dotnet_dest_loc_abs_final" ]; then
    echo "Destination directory '$dotnet_dest_loc_abs_final' already exists. Exiting."
    exit 1
fi

# Copy dotnet_src_loc_abs to dotnet_dest_loc_abs
cp -r "$dotnet_src_loc_abs" "$dotnet_dest_loc_abs"

# Change to destination directory
cd "$dotnet_dest_loc_abs" || exit 1

# Step 1: Rename directories
find . -depth -type d -name "*$template_name*" | while read -r dir; do
    newdir=$(echo "$dir" | sed "s/$template_name/$component_name/g")
    mv "$dir" "$newdir"
done

# Step 2: Rename files
find . -depth -type f -name "*$template_name*" | while read -r file; do
    newfile=$(echo "$file" | sed "s/$template_name/$component_name/g")
    mv "$file" "$newfile"
done

# Step 3: Replace content inside files
# Only process text files (heuristically using 'file' command)
find . -type f | while read -r file; do
    if file "$file" | grep -qE 'text'; then
        sed -i "s/$template_name/$component_name/g" "$file"
        sed -i "s/$TEMPLATE_NAMESPACE/$COMPONENT_NAMESPACE/g" "$file"
    fi
done

echo "Dotnet part copied, all replacements done successfully."
