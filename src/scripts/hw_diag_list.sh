if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <PLC_IP_ADDRESS> <PLC_NAME>"
    exit 1
fi
PLC_IP_ADDRESS=$1
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
    echo "The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address."
    exit 1
fi
PLC_NAME=$2
if [ -z "$PLC_NAME" ]; then
    echo "The PLC_NAME could not be an empty string."
    exit 1
fi
PLC_CERT=./certs/$PLC_NAME/$PLC_NAME.cer
if ! [[ -e $PLC_CERT ]]; then
	echo "Certificate file $PLC_CERT not found!!!"
    exit 1
fi
apax hw-diag list -t $PLC_IP_ADDRESS -C $PLC_CERT
