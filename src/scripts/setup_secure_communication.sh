if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <PLC_NAME> <USERNAME> <PASSWORD>"
    exit 1
fi

PLC_NAME=$1
if [ -z $PLC_NAME ]; then
    echo "The PLC_NAME could not be an empty string."
    exit 1
fi

USERNAME=$2
if [ -z $USERNAME ]; then
    echo "The USERNAME could not be an empty string."
    exit 1
fi

PASSWORD=$3
if [ -z $PASSWORD ]; then
    echo "The PASSWORD could not be an empty string."
    exit 1
fi

if ! [[ -d "./hwc" ]]; then
  echo "Directory ".\hwc" does not exist!!!"
  exit 1
fi

hwcfile=".\hwc\\${PLC_NAME}.hwl.json"
if [ ! -e $hwcfile ]; then
  echo "Hardware configuration file $hwcfile does not exist!!!"
  exit 1
fi

certificesExist=1

certificateForConnection="./certs/$PLC_NAME/certificateForConnection.crt"
if [ ! -f $certificateForConnection ]; then
  echo $certificateForConnection " does not exist!!!"
  certificesExist=0
fi

pkcs12ForCertificateImport="./certs/$PLC_NAME/pkcs12ForCertificateImport.p12"
if [ ! -f $certifpkcs12ForCertificateImporticateForConnection ]; then
  echo $pkcs12ForCertificateImport " does not exist!!!"
  certificesExist=0
fi

privateKey="./certs/$PLC_NAME/privateKey.pem"
if [ ! -f $privateKey ]; then
  echo $privateKey " does not exist!!!"
  certificesExist=0
fi

server_cert="./certs/$PLC_NAME/server.cert.pem"
if [ ! -f $server_cert ]; then
  echo $server_cert " does not exist!!!"
  certificesExist=0
fi

server="./certs/$PLC_NAME/server.csr"
if [ ! -f $server ]; then
  echo $server " does not exist!!!"
  certificesExist=0
fi

server_cert_ext="./certs/$PLC_NAME/server_cert_ext.cnf"
if [ ! -f $certificateForConnection ]; then
  echo $server_cert_ext " does not exist!!!"
  certificesExist=0
fi

createCertificateViaOpenSSL="./certs/$PLC_NAME/createCertificateViaOpenSSL.bat"
if [ -f $createCertificateViaOpenSSL ]; then
  rm $createCertificateViaOpenSSL
  echo $createCertificateViaOpenSSL " was deleted!!!"
fi

if [ $certificesExist -eq 0 ]; then

  if [ -d "./certs/$PLC_NAME" ]; then
    rm -Rf "./certs/$PLC_NAME"
    echo " Folder ./certs/$PLC_NAME deleted."
  fi

  if ! [[ -d "./certs" ]]; then
    mkdir "./certs"
    echo " Folder ./certs created."
  fi

  if ! [[ -d "./certs/$PLC_NAME" ]]; then
    mkdir "./certs/$PLC_NAME"
    echo " Folder ./certs/$PLC_NAME created."
  fi

  echo "basicConstraints = CA:FALSE" > $server_cert_ext

  workDir=$(PWD)
  cd ./certs/$PLC_NAME

  echo off

  echo "Step1 of PKCS12 file creation STARTED: generating private key"
  openssl genrsa -out privateKey.pem 2048
  echo "Step1 of PKCS12 file creation COMPLETED: privateKey.pem is generated"
  
  echo "Step2 of PKCS12 file creation STARTED: generating certificate request"
  MSYS_NO_PATHCONV=1 openssl req -new -key privateKey.pem -out server.csr -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
  echo "Step2 of PKCS12 file creation COMPLETED : server.csr is generated"
  
  echo "Step3 of PKCS12 file creation STARTED: generating end-entity certificate"
  openssl x509 -req -in server.csr -signkey privateKey.pem -out server.cert.pem -days 365 -sha256 -extfile server_cert_ext.cnf
  echo "Step3 of PKCS12 file creation COMPLETED: generating end-entity certificate"
  
  echo "Step4 of PKCS12 file creation STARTED: export certificate in pkcs12 format"
  openssl pkcs12 -export -in server.cert.pem -inkey privateKey.pem -out pkcs12ForCertificateImport.p12 -password pass:$PASSWORD
  echo "Step4 of PKCS12 file creation COMPLETED: export certificate in pkcs12 format" 
  
  echo "Certificate with public key creation STARTED"
  openssl pkcs12 -in pkcs12ForCertificateImport.p12 -out certificateForConnection.crt -nokeys -password pass:$PASSWORD
  echo "Certificate with public key creation COMPLETED" 

  cd $workDir
fi

seconfile=".\hwc\hwc.gen\\${PLC_NAME}.SecurityConfiguration.json"
if [ -e "$seconfile" ]; then
  rm "$seconfile"
fi

apax hwc setup-secure-communication -n $PLC_NAME -i ".\hwc" -p $PASSWORD
apax hwc import-certificate -n $PLC_NAME -i ".\hwc" -C "./certs/$PLC_NAME/pkcs12ForCertificateImport.p12" -p $PASSWORD --purpose "TLS"
apax hwc import-certificate -n $PLC_NAME -i ".\hwc" -C "./certs/$PLC_NAME/pkcs12ForCertificateImport.p12" -p $PASSWORD --purpose "WebServer"
apax hwc manage-users -n $PLC_NAME -i ".\hwc" set-password -u $USERNAME -p $PASSWORD