exportdir="./dcp_export"
if ! [[ -d $exportdir ]]; then
  echo "Directory $exportdir does not exist!!!"
  mkdir -p $exportdir
fi
exportfile=$exportdir"/interfaces.json"
if [ -f $exportfile ]; then
  echo "File $exportfile already exist!!!"
  rm $exportfile
  echo $exportfile " was deleted!!!"
fi

apax dcp-utility list-interfaces -f JSON > $exportfile 












