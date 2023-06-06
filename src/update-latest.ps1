$root = pwd

cd abstractions\ctrl
apax update --all
cd $root

cd core\ctrl
apax update --all
cd $root

cd data\ctrl
apax update --all
cd $root

cd integrations\ctrl
apax update --all
cd $root

cd probers\ctrl
apax update --all
cd $root

cd simatic1500\ctrl
apax update --all
cd $root

cd templates.simple\ctrl
apax update --all
cd $root

cd utils\ctrl
apax update --all
cd $root
