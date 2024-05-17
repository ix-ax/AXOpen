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

#apax run ci                                  # clean and install dependencies
apax clean
apax install

#clean_plc                                    # total reset of the PLC excluding IP and name
clean_plc=$( dirname ${BASH_SOURCE[0]})"\\clean_plc.sh"
$clean_plc

#copy_and_install_gsd                         # copy and install all gsdml files from library           
copy_and_install_gsd=$( dirname ${BASH_SOURCE[0]})"\\copy_and_install_gsd.sh"
$copy_and_install_gsd

#copy_hwl_templates                           # copy all templates from library  
copy_hwl_templates=$( dirname ${BASH_SOURCE[0]})"\\copy_hwl_templates.sh"
$copy_hwl_templates

#setup_secure_communication                   # setup secure communication, create and import certificates, setup password for AX_USERNAME 
setup_secure_communication=$( dirname ${BASH_SOURCE[0]})"\\setup_secure_communication.sh"
$setup_secure_communication $PLC_NAME $USERNAME $PASSWORD

#hw_first_compile_and_first_download          # compile, copy the HwIds, first download HW using password and upload certificate       
hw_first_compile_and_first_download=$( dirname ${BASH_SOURCE[0]})"\\hw_first_compile_and_first_download.sh"
$hw_first_compile_and_first_download $PLC_NAME $PLC_IP_ADDRESS $PASSWORD

#sw_build_and_download_full                   # software build and full download
sw_build_and_download_full=$( dirname ${BASH_SOURCE[0]})"\\sw_build_and_download_full.sh"
$sw_build_and_download_full $PLC_NAME $PLC_IP_ADDRESS $PLATFORM
