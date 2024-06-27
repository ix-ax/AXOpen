if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM> <USERNAME> <PASSWORD>"
    exit 1
fi

PLC_NAME=$1
if [ -z $PLC_NAME ]; then
    echo "The PLC_NAME could not be an empty string."
    exit 1
fi

PLC_IP_ADDRESS=$2
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
    echo "The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address."
    exit 1
fi

PLATFORM=$3
if [ -z $PLATFORM ]; then
    echo "The PLATFORM could not be an empty string."
    exit 1
fi

USERNAME=$4
if [ -z $USERNAME ]; then
    echo "The USERNAME could not be an empty string."
    exit 1
fi

PASSWORD=$5
if [ -z $PASSWORD ]; then
    echo "The PASSWORD could not be an empty string."
    exit 1
fi

certfile="./certs/$PLC_NAME/$PLC_NAME.cer" 
if [ -e "$certfile" ]; then
	echo "Certification file $certfile exists."
	#apax run ci                                  # clean and install dependencies
	apax clean
	apax install

	#hw_update                                    # copy and install gsd, copy templates, compile, copy the HwIds, download HW using certificate
	hw_update=$( dirname ${BASH_SOURCE[0]})"\\hw_update.sh"
	$hw_update $PLC_NAME $PLC_IP_ADDRESS 

	#sw_build_and_download_full                   # software build and full download
	sw_build_and_download_full=$( dirname ${BASH_SOURCE[0]})"\\sw_build_and_download_full.sh"
	$sw_build_and_download_full $PLC_NAME $PLC_IP_ADDRESS $PLATFORM
  
else
	echo "Certification file $certfile does not exist."
	#alf 										#clear plc except ip and name and provide all actions for install all, build and initial download hw so as sw
	alf=$( dirname ${BASH_SOURCE[0]})"\\all_first.sh"
	$alf $PLC_NAME $PLC_IP_ADDRESS $PLATFORM $USERNAME $PASSWORD
fi 


