use_plcsim=AXUSEPLCSIM
use_plcsim_value=$(printenv "$use_plcsim")

if [ -z "$use_plcsim_value" ]; then
	echo "Environment variable '$use_plcsim' is not set."
else
	echo "The value of '$use_plcsim' is: $use_plcsim_value"

	if [ "$(echo 'true' | tr '[:upper:]' '[:lower:]')" == "$(echo "$use_plcsim_value" | tr '[:upper:]' '[:lower:]')" ]; then
		plcsimscript=$( dirname ${BASH_SOURCE[0]})"\\StartPlcSimAdvCli.exe"
		$plcsimscript
		status=$?
		if [ $status -ne 0 ]; then
		  echo "Plcsim script failed with exit status $status."
		fi
	fi
fi
		