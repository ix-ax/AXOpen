if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <NAMESPACE> <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM> <USERNAME> <PASSWORD>"
    exit 1
fi

NAMESPACE=$1
if [ -z $NAMESPACE ]; then
    echo "The NAMESPACE could not be an empty string."
    exit 1
fi

PLC_NAME=$2
if [ -z $PLC_NAME ]; then
    echo "The PLC_NAME could not be an empty string."
    exit 1
fi

PLC_IP_ADDRESS=$3
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
    echo "The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address."
    exit 1
fi

PLATFORM=$4
if [ -z $PLATFORM ]; then
    echo "The PLATFORM could not be an empty string."
    exit 1
fi

USERNAME=$5
if [ -z $USERNAME ]; then
    echo "The USERNAME could not be an empty string."
    exit 1
fi

PASSWORD=$6
if [ -z $PASSWORD ]; then
    echo "The PASSWORD could not be an empty string."
    exit 1
fi

export GREEN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color


certfile="./certs/$PLC_NAME/$PLC_NAME.cer" 
if ! [[ -e "$certfile" ]]; then
	printf "${RED}Certification file $certfile does not exist.\r\n${NC}"
	#alf 										#clear plc except ip and name and provide all actions for install all, build and initial download hw so as sw
	alf=$( dirname ${BASH_SOURCE[0]})"\\all_first.sh"
	$alf $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS $PLATFORM $USERNAME $PASSWORD
else
	check_requisites_apax_script=$( dirname ${BASH_SOURCE[0]})"\\check_requisites_apax.sh"
	if ! $check_requisites_apax_script ; then
		exit 1
	fi

	check_requisites_nuget_script=$( dirname ${BASH_SOURCE[0]})"\\check_requisites_nuget.sh"
	if ! $check_requisites_nuget_script ; then
		exit 1
	fi

	plcsim_script=$( dirname ${BASH_SOURCE[0]})"\\plcsim.sh"
	$plcsim_script

	#apax run ci                                  # clean and install dependencies
	apax clean
	apax install

	is_cert_hash_sha1_equal_script=$( dirname ${BASH_SOURCE[0]})"\\is_cert_hash_sha1_equal.sh"
	if ! $is_cert_hash_sha1_equal_script "$PLC_NAME" "$PLC_IP_ADDRESS"; then
		printf "${RED}Certification file $certfile exists, but its sha1 hash is different to the PLC's one.\r\n"
		printf "${RED}It has to be regenerated again.\r\n${NC}"
		#alf										  #clear plc except ip and name and provide all actions for install all, build and initial download hw so as sw
		alf=$( dirname ${BASH_SOURCE[0]})"\\all_first.sh"
		$alf $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS $PLATFORM $USERNAME $PASSWORD
	else
	
		printf "${GREEN}Certification file $certfile exists and its sha1 hash is equal to the PLC's one.\r\n"
		printf "${GREEN}No prompt will popup during execution, so you could leave your PC and enjoy your coffee now.\r\n${NC}"


		#hw_update                                    # copy and install gsd, copy templates, compile, copy the HwIds, download HW using certificate
		hw_update=$( dirname ${BASH_SOURCE[0]})"\\hw_update.sh"
		$hw_update $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS 

		#sw_build_and_download_full                   # software build and full download
		sw_build_and_download_full=$( dirname ${BASH_SOURCE[0]})"\\sw_build_and_download_full.sh"
		$sw_build_and_download_full $PLC_NAME $PLC_IP_ADDRESS $PLATFORM
	fi
fi 


