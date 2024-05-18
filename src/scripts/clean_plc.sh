if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <PLC_IP_ADDRESS>"
    exit 1
fi
PLC_IP_ADDRESS=$1
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
    echo "The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address."
    exit 1
fi
apax hwld -t $PLC_IP_ADDRESS --resetPlc keepOnlyIP --accept-security-disclaimer