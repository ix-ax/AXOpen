export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF
if [ "$#" -ne 7 ]; then
    printf "${RED}Usage: $0 <NAMESPACE> <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM> <USERNAME> <PASSWORD> <USE_PLC_SIM_ADVANCED>\r\n${NC}"
    exit 1
fi

NAMESPACE=$1
if [ -z $NAMESPACE ]; then
    printf "${RED}The NAMESPACE could not be an empty string.\r\n${NC}"
    exit 1
fi

PLC_NAME=$2
if [ -z $PLC_NAME ]; then
    printf "${RED}The PLC_NAME could not be an empty string.\r\n${NC}"
    exit 1
fi

PLC_IP_ADDRESS=$3
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
    printf "${RED}The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address.\r\n${NC}"
    exit 1
fi

PLATFORM=$4
if [ -z $PLATFORM ]; then
    printf "${RED}The PLATFORM could not be an empty string.\r\n${NC}"
    exit 1
fi

USERNAME=$5
if [ -z $USERNAME ]; then
    printf "${RED}The USERNAME could not be an empty string.\r\n${NC}"
    exit 1
fi

PASSWORD=$6
if [ -z $PASSWORD ]; then
    printf "${RED}The PASSWORD could not be an empty string.\r\n${NC}"
    exit 1
fi

USE_PLC_SIM_ADVANCED=$7
if [ -z $USE_PLC_SIM_ADVANCED ]; then
    printf "${RED}The USE_PLC_SIM_ADVANCED could not be an empty string.\r\n${NC}"
    exit 1
fi

#compile_all							# compile hw and sw
cla=$( dirname ${BASH_SOURCE[0]})"\\compile_all.sh"
$cla $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS $PLATFORM $USERNAME $PASSWORD $USE_PLC_SIM_ADVANCED 

#compare_all							# compare offline and online 
cpa=$( dirname ${BASH_SOURCE[0]})"\\compare_all.sh"
$cpa  $PLC_NAME $PLC_IP_ADDRESS $PLATFORM $USERNAME $PASSWORD  
