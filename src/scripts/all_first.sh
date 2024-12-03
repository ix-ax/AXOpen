export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF
if [ "$#" -ne 6 ]; then
    printf "${RED}Usage: $0 <NAMESPACE> <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM> <USERNAME> <PASSWORD>\r\n${NC}"
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

printf "${RED}This command will prompt during execution, so do not leave your PC. You can enjoy your coffee afterward.\r\n${NC}"

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

#clean_plc                                    # total reset of the PLC excluding IP and name
clean_plc=$( dirname ${BASH_SOURCE[0]})"\\clean_plc.sh"
$clean_plc $PLC_IP_ADDRESS

#copy_and_install_gsd                         # copy and install all gsdml files from library           
copy_and_install_gsd=$( dirname ${BASH_SOURCE[0]})"\\copy_and_install_gsd.sh"
$copy_and_install_gsd
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Gsdml files installed succesfully.${NC}"
else
	printf "${RED}Installation of the gsdml files finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi

#copy_hwl_templates                           # copy all templates from library  
copy_hwl_templates=$( dirname ${BASH_SOURCE[0]})"\\copy_hwl_templates.sh"
$copy_hwl_templates
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Copying hardware templates from the libraries finished succesfully.${NC}"
else
	printf "${RED}Copying hardware templates from the libraries finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi

#setup_secure_communication                   # setup secure communication, create and import certificates, setup password for AX_USERNAME 
setup_secure_communication=$( dirname ${BASH_SOURCE[0]})"\\setup_secure_communication.sh"
$setup_secure_communication $PLC_NAME $USERNAME $PASSWORD
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Configuring secure communication finished succesfully.${NC}"
else
	printf "${RED}Configuring secure communication finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi

#hw_first_compile_and_first_download          # compile, copy the HwIds, first download HW using password and upload certificate       
hw_first_compile_and_first_download=$( dirname ${BASH_SOURCE[0]})"\\hw_first_compile_and_first_download.sh"
$hw_first_compile_and_first_download $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS $PASSWORD
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Hardware configuration has been succesfully compiled and downloaded.${NC}"
else
	printf "${RED}Compilation of the hardware configuration or its downloaded finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi

#sw_build_and_download_full                   # software build and full download
sw_build_and_download_full=$( dirname ${BASH_SOURCE[0]})"\\sw_build_and_download_full.sh"
$sw_build_and_download_full $PLC_NAME $PLC_IP_ADDRESS $PLATFORM
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Software has been succesfully compiled and downloaded.${NC}"
else
	printf "${RED}Compilation of the software or its downloaded finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi