export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

if [ "$#" -ne 5 ]; then
	printf "${RED}Usage: $0 <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM> <USERNAME> <PASSWORD>.${NC}"
    exit 1
fi

PLC_NAME=$1
if [ -z $PLC_NAME ]; then
	printf "${RED}The PLC_NAME could not be an empty string.${NC}"
    exit 1
fi

PLC_IP_ADDRESS=$2
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
	printf "${RED}The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address.${NC}"
    exit 1
fi

PLATFORM=$3
if [ -z $PLATFORM ]; then
	printf "${RED}The PLATFORM could not be an empty string.${NC}"
    exit 1
fi

USERNAME=$4
if [ -z $USERNAME ]; then
    printf "${RED}The USERNAME could not be an empty string.\r\n${NC}"
    exit 1
fi

PASSWORD=$5
if [ -z $PASSWORD ]; then
    printf "${RED}The PASSWORD could not be an empty string.\r\n${NC}"
    exit 1
fi

certfile="./certs/$PLC_NAME/$PLC_NAME.cer"
if ! [[ -e "$certfile" ]]; then
	printf "${RED}Certification file $certfile does not exist!!!${NC}"
	exit 1
fi   
result_file=".\online_offline_compare_result.txt"
if [ -f "$result_file" ] ; then
    rm "$result_file"
fi

apax sld compare --mode all --target $PLC_IP_ADDRESS --input $PLATFORM --username $USERNAME --password $PASSWORD --certificate $certfile --log Information | tee $result_file
exit_code=${PIPESTATUS[0]}
echo "exit_code: $exit_code"

if [[ $exit_code -eq 0 ]]; then
	printf "${GREEN}The compiled software and loaded one are identical.${NC}"
elif [[ $exit_code -eq 9 ]]; then
	printf "${YELLOW}At least one code block is different between the compiled software and loaded one.${NC}"
elif [[ $exit_code -eq 10 ]]; then
	printf "${YELLOW}At least one data block is different between the compiled software and loaded one.${NC}"
elif [[ $exit_code -eq 11 ]]; then
	printf "${YELLOW}At least one code block and one data block are different the compiled software and loaded one.${NC}"
else
	printf "${RED}Unspecified return code during comparing!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi