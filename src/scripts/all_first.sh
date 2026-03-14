export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF

# Function to validate password does not contain problematic shell characters
validate_password_safe_chars() {
    local password="$1"
    
    # Check for problematic characters: $ ` \ " ' & | ; < > ( ) * ? [ ] { } or whitespace
    if [[ "$password" =~ [\$\`\\\"\'\&\|\;\<\>\(\)\*\?\[\]\{\}[:space:]] ]]; then
        return 1
    fi
    return 0
}

if [ "$#" -ne 8 ]; then
    printf "${RED}Usage: $0 <NAMESPACE> <PLC_NAME> <PLC_IP_ADDRESS> <PLATFORM> <USERNAME> <PASSWORD> <USE_PLC_SIM_ADVANCED> <FORCE>\r\n${NC}"
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

# Validate password does not contain problematic shell characters
if ! validate_password_safe_chars "$PASSWORD"; then
    printf "${RED}The PASSWORD contains problematic characters.\r\n${NC}"
    printf "${RED}Cannot use: \$ \` \\ \" ' & | ; < > ( ) * ? [ ] { } or whitespace\r\n${NC}"
    exit 1
fi

USE_PLC_SIM_ADVANCED=$7
if [ -z $USE_PLC_SIM_ADVANCED ]; then
    printf "${RED}The USE_PLC_SIM_ADVANCED could not be an empty string.\r\n${NC}"
    exit 1
fi

if [ "$8" = "true" ]; then
	echo "Project certificate is going to be deleted and regenerated again."
	FORCE=true
else
	echo "Project certificate is going to be generated if it does not already exists."
	FORCE=false
fi

PLCSIM=0
case "$(echo "$USE_PLC_SIM_ADVANCED" | tr '[:upper:]' '[:lower:]')" in
    "true")
        PLCSIM=1
        printf "${YELLOW} USE_PLC_SIM_ADVANCED is true. ${NC}"
        ;;
    "false")
        PLCSIM=0
        printf "${YELLOW} USE_PLC_SIM_ADVANCED is false. ${NC}"
        ;;
    *)
         printf "${RED}USE_PLC_SIM_ADVANCED has an invalid or undefined value: '$USE_PLC_SIM_ADVANCED'.${NC}"
        ;;
esac

printf "${YELLOW}This command will prompt during execution, so do not leave your PC. You can enjoy your coffee afterward.\r\n${NC}"

check_requisites_apax_script=$( dirname ${BASH_SOURCE[0]})"\\check_requisites_apax.sh"
if ! $check_requisites_apax_script ; then
	exit 1
fi

check_requisites_nuget_script=$( dirname ${BASH_SOURCE[0]})"\\check_requisites_nuget.sh"
if ! $check_requisites_nuget_script ; then
	exit 1
fi

check_requisites_custom_registry_script=$( dirname ${BASH_SOURCE[0]})"\\check_requisites_custom_registry.sh"
if ! $check_requisites_custom_registry_script ; then
	exit 1
fi


if [ "$PLCSIM" -eq 1 ]; then
	plcsim_script=$( dirname ${BASH_SOURCE[0]})"\\plcsimadvanced.sh"
	$plcsim_script $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS
fi


#apax run ci                                  # clean and install dependencies
apax clean
apax install --catalog
apax install

if [ "$FORCE" = "true" ]; then
	certs_folder="./certs"
    rm -rf "${certs_folder:?}/"*
	hwc_gen_folder="./hwc/hwc.gen"
    rm -rf "${hwc_gen_folder:?}/"*
fi
#clean_plc                                    # total reset of the PLC excluding IP and name
clean_plc=$( dirname ${BASH_SOURCE[0]})"\\clean_plc.sh"
$clean_plc $PLC_IP_ADDRESS $USERNAME $PASSWORD


#hw_first_download          # copy gsd, copy hwl, setup secure communication,  compile, copy the HwIds, first download HW using password and upload certificate       
hw_first_download=$( dirname ${BASH_SOURCE[0]})"\\hw_first_download.sh"
$hw_first_download $NAMESPACE $PLC_NAME $PLC_IP_ADDRESS $USERNAME $PASSWORD 
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Hardware configuration has been succesfully compiled and downloaded.${NC}"
else
	printf "${RED}Compilation of the hardware configuration or its downloaded finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi

#sw_build_and_download_full                   # software build and full download
sw_build_and_download_full=$( dirname ${BASH_SOURCE[0]})"\\sw_build_and_download_full.sh"
$sw_build_and_download_full $PLC_NAME $PLC_IP_ADDRESS $PLATFORM $USERNAME $PASSWORD 
if [[ $? -eq 0 ]]; then
	printf "${GREEN}Software has been succesfully compiled and downloaded.${NC}"
else
	printf "${RED}Compilation of the software or its downloaded finished with an error!${NC}\n"
	printf "${RED}Please check the details above.${NC}\n"
	exit 1
fi


