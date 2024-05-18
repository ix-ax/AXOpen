if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM>"
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

#apax run ci                                  # clean and install dependencies
apax clean
apax install

#hw_update                                    # copy and install gsd, copy templates, compile, copy the HwIds, download HW using certificate
hw_update=$( dirname ${BASH_SOURCE[0]})"\\hw_update.sh"
$hw_update $PLC_NAME $PLC_IP_ADDRESS 

#sw_build_and_download_full                   # software build and full download
sw_build_and_download_full=$( dirname ${BASH_SOURCE[0]})"\\sw_build_and_download_full.sh"
$sw_build_and_download_full $PLC_NAME $PLC_IP_ADDRESS $PLATFORM
