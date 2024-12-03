export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

use_plcsim=AXUSEPLCSIM
use_plcsim_value=$(printenv "$use_plcsim")

if [ -z "$use_plcsim_value" ]; then
	printf "${YELLOW}Environment variable '$use_plcsim' is not set.${NC}"
else
	printf "${YELLOW}The value of '$use_plcsim' is: $use_plcsim_value.${NC}"

	if [ "$(echo 'true' | tr '[:upper:]' '[:lower:]')" == "$(echo "$use_plcsim_value" | tr '[:upper:]' '[:lower:]')" ]; then
		plcsimscript=$( dirname ${BASH_SOURCE[0]})"\\StartPlcSimAdvCli.exe"
		$plcsimscript
		status=$?
		if [ $status -ne 0 ]; then
			printf "${RED}Plcsim script failed with exit status $status.${NC}"
		fi
	fi
fi
		