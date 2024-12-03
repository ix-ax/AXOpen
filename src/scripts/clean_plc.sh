export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

if [ "$#" -ne 1 ]; then
	printf "${RED}Usage: $0 <PLC_IP_ADDRESS>.\r\n${NC}"
    exit 1
fi
PLC_IP_ADDRESS=$1
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
    printf "${RED}The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address.\r\n${NC}"
    exit 1
fi
apax hwld -t $PLC_IP_ADDRESS --resetPlc keepOnlyIP --accept-security-disclaimer
if [[ $? -eq 0 ]]; then
	printf "${GREEN}PLC was reseted succesfully.${NC}"
else
	printf "${RED}Unable to reset the PLC!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi