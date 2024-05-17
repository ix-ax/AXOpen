if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <MAC_ADDRESS>"
    exit 1
fi

MAC_ADDRESS=$1
if [ -z $MAC_ADDRESS ]; then
    echo "The MAC_ADDRESS could not be an empty string."
    exit 1
fi

regex="^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$"

if ! [[ $MAC_ADDRESS =~ $regex ]]; then
    echo "The $MAC_ADDRESS is not valid MAC address."
    exit 1
fi

exportdir="./dcp_export"
if ! [[ -d $exportdir ]]; then
  echo "Directory $exportdir does not exist!!!"
  mkdir -p $exportdir
fi
exportfile=$exportdir"/devices.json"
if [ -f $exportfile ]; then
  echo "File $exportfile already exist!!!"
  rm $exportfile
  echo $exportfile " was deleted!!!"
fi

apax dcp-utility discover --source-mac $MAC_ADDRESS --timeout 30000 > $exportfile