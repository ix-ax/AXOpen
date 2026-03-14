export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m\r\n' # No Color+CRLF
if [ "$#" -ne 4 ]; then
	printf "${RED}Usage: $0 <PLC_NAME> <USERNAME> <PASSWORD> <IPADDRESS>.${NC}"
    exit 1
fi

PLC_NAME=$1
if [ -z $PLC_NAME ]; then
	printf "${RED}The PLC_NAME could not be an empty string.${NC}"
    exit 1
fi

USERNAME=$2
if [ -z $USERNAME ]; then
	printf "${RED}The USERNAME could not be an empty string.${NC}"
    exit 1
fi

PASSWORD=$3
if [ -z $PASSWORD ]; then
	printf "${RED}The PASSWORD could not be an empty string.${NC}"
    exit 1
fi

IP_ADDRESS=$4
validate_script=$( dirname ${BASH_SOURCE[0]})"\\validate_ip.sh"
if ! $validate_script "$IP_ADDRESS"; then
	printf "${RED}The IP_ADDRESS '$IP_ADDRESS' is not a valid IP address.${NC}"
    exit 1
fi

DNSNAME=""
URI=""

if ! [[ -d "./hwc" ]]; then
	printf "${RED}Directory ".\hwc" does not exist!!!${NC}"
	exit 1
fi

hwcfile=".\hwc\\${PLC_NAME}.hwl.yml"
if [ ! -f $hwcfile ]; then
	printf "${RED}Hardware configuration file $hwcfile does not exist!!!${NC}"
	exit 1
fi

message="If you want to change the security configuration, you must delete it manually before triggering this command.${NC}"
file=".\hwc\hwc.gen\\${PLC_NAME}.SecurityConfiguration.json"
if [ -f "$file" ]; then
	printf "${YELLOW}File '$file' already exists.${NC}"
	printf "${YELLOW}${message}"
	exit 1
fi

file="./certs/$PLC_NAME/containerWithPublicAndPrivateKeys_x509.p12"
if [ -f "$file" ]; then
	printf "${YELLOW}File '$file' already exists.${NC}"
	printf "${YELLOW}${message}"
	exit 1
fi

file="./certs/$PLC_NAME/reference_x509.crt"
if [ -f "$file" ]; then
	printf "${YELLOW}File '$file' already exists.${NC}"
	printf "${YELLOW}${message}"
	exit 1
fi

file="./certs/$PLC_NAME/$PLC_NAME.cer"
if [ -f "$file" ]; then
	printf "${YELLOW}File '$file' already exists.${NC}"
	printf "${YELLOW}${message}"
	exit 1
fi

file="./certs/$PLC_NAME/privateKey.pem"
if [ -f "$file" ]; then
	printf "${YELLOW}File '$file' already exists.${NC}"
	rm $file
	printf "${YELLOW}File '$file' deleted.${NC}"
fi

file="./certs/$PLC_NAME/server.cert.pem"
if [ -f "$file" ]; then
	printf "${YELLOW}File '$file' already exists.${NC}"
	rm $file
	printf "${YELLOW}File '$file' deleted.${NC}"
fi

server_cert_ext="./certs/$PLC_NAME/server_cert_ext.cnf"
if [ -f "$server_cert_ext" ]; then
	printf "${YELLOW}File '$server_cert_ext' already exists.${NC}"
	rm $server_cert_ext
	printf "${YELLOW}File '$server_cert_ext' deleted.${NC}"
fi

if ! [[ -d "./certs" ]]; then
  mkdir "./certs"
  printf "Folder ./certs created.${NC}"
fi

if ! [[ -d "./certs/$PLC_NAME" ]]; then
  mkdir "./certs/$PLC_NAME"
  printf "Folder ./certs/$PLC_NAME created.${NC}"
fi

COMMON_NAME="${DNSNAME:-localhost}"
PKCS12_PASS_ARG="-passout pass:${PASSWORD}"
PKCS12_PASS_IN_ARG="-passin pass:${PASSWORD}"
#===== Write OpenSSL config =====	
cat > "$server_cert_ext" <<EOF
[ req ]
default_bits       = 2048
default_md         = sha256
distinguished_name = dn
x509_extensions    = v3_req
prompt             = no

[ dn ]
C  = XX
ST = StateName
L  = CityName
O  = CompanyName
OU = CompanySectionName
CN = ${COMMON_NAME}

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature, nonRepudiation, keyCertSign, keyCertSign, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = @alt_names
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always

[ alt_names ]
DNS.1 = ${DNSNAME}
IP.1 = ${IP_ADDRESS}
URI.1 = ${URI}
EOF

printf "Configuration written to $server_cert_ext.${NC}"

workDir=$(PWD)
cd ./certs/$PLC_NAME

echo off

echo Generating private key...
openssl genrsa -out privateKey.pem 2048

echo Generating self-signed certificate...
openssl req -new -x509 -days 3650 -key privateKey.pem -out server.cert.pem -config server_cert_ext.cnf -extensions v3_req

echo Exporting to PKCS12...
openssl pkcs12 -export -in server.cert.pem -inkey privateKey.pem -out containerWithPublicAndPrivateKeys_x509.p12 $PKCS12_PASS_ARG

echo Exporting certificate only crt...
openssl pkcs12 -in containerWithPublicAndPrivateKeys_x509.p12 -out reference_x509.crt -nokeys $PKCS12_PASS_IN_ARG

rm privateKey.pem
rm server.cert.pem
rm server_cert_ext.cnf

cd $workDir

apax hwc setup-secure-communication --module-name $PLC_NAME --no-input --input ".\hwc" --master-password $PASSWORD
apax hwc import-certificate --module-name $PLC_NAME --input ".\hwc" --certificate "./certs/$PLC_NAME/containerWithPublicAndPrivateKeys_x509.p12" --passphrase $PASSWORD --purpose "TLS"
apax hwc import-certificate --module-name $PLC_NAME --input ".\hwc" --certificate "./certs/$PLC_NAME/containerWithPublicAndPrivateKeys_x509.p12" --passphrase $PASSWORD --purpose "WebServer"
apax hwc set-accessprotection-password --module-name $PLC_NAME --input ".\hwc" --level "FullAccess" --password $PASSWORD
apax hwc manage-users --module-name $PLC_NAME --input ".\hwc" set-password --username $USERNAME --password $PASSWORD