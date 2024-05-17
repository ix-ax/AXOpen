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

apax build --ignore-scripts
dotnet ixc
certfile="./certs/$PLC_NAME/$PLC_NAME.cer"
if ! [[ -e "$certfile" ]]; then
  echo "Certification file $certfile does not exist!!!"
  exit 1
fi   
apax sld load --accept-security-disclaimer -t $PLC_IP_ADDRESS -i $PLATFORM -r -C $certfile --mode delta