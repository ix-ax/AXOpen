#!/bin/bash

# Function to compare certification hash SHA1
is_cert_hash_sha1_equal() {
	local plc_name=$1
	local plc_ip=$2
	certfile="./certs/$plc_name/$plc_name.cer" 
	
	# Run certutil -dump on the provided certification file and extract the SHA1 key
	sha1_key_certfile=$(certutil -dump "$certfile" | grep -i "Cert Hash(sha1)" | awk '{print $NF}')
	
	apax plc-cert -t $plc_ip -o "_temp.cer" 
	sha1_key_plc=$(certutil -dump _temp.cer | grep -i "Cert Hash(sha1)" | awk '{print $NF}')
	rm _temp.cer

    if [[ "$sha1_key_certfile" == "$sha1_key_plc" ]]; then
		echo "$sha1_key_certfile"
		echo "$sha1_key_plc"
		return 0
    else
		echo "$sha1_key_certfile"
		echo "$sha1_key_plc"
		return 1
    fi
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <PLC_NAME> <PLC_IP_ADDRESS>"
	exit 1
fi
	
PLC_NAME=$1
if [ -z $PLC_NAME ]; then
	echo "The PLC_NAME could not be an empty string."
	exit 1
fi

PLC_IP_ADDRESS=$2
validate_script=$( dirname ${BASH_SOURCE[0]})"/validate_ip.sh"
if ! $validate_script "$PLC_IP_ADDRESS"; then
	echo "The PLC_IP_ADDRESS '$PLC_IP_ADDRESS' is not a valid IP address."
	exit 1
fi
	
# Validate the input parameter
if ! is_cert_hash_sha1_equal "$1" "$2"; then
    echo "The hash of the stored certification file: $certfile and the certificate inside the PLC with IP address: $PLC_IP_ADDRESS are different."
    exit 1
else 
    echo "The hash of the stored certification file: $certfile and the certificate inside the PLC with IP address: $PLC_IP_ADDRESS are equal."
    exit 0
fi
