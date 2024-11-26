if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <NAMESPACE> <PLC_NAME> <PLC_IP_ADDRESS>"
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

#copy_and_install_gsd                         # copy and install all gsdml files from library           
copy_and_install_gsd=$( dirname ${BASH_SOURCE[0]})"\\copy_and_install_gsd.sh"
$copy_and_install_gsd

#copy_hwl_templates                           # copy all templates from library  
copy_hwl_templates=$( dirname ${BASH_SOURCE[0]})"\\copy_hwl_templates.sh"
$copy_hwl_templates

#hw_compile_and_download                      # compile, copy the HwIds, download HW using certificate 
hw_compile_and_download=$( dirname ${BASH_SOURCE[0]})"\\hw_compile_and_download.sh"
$hw_compile_and_download $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS
