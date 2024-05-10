#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


rm -f *.p12

export CN=${1:-localhost}
export SUBJECT_ALT_NAMES=${2:-"DNS:localhost,IP:127.0.0.1"}
export SECRET=tests3cret
export JKS_FILE=test-keystore.jks
export JKS_TRUST_FILE=test-truststore.jks
export CERT_FILE=localhost.crt
export PKCS_FILE=test-keystore.p12
export PKCS_TRUST_FILE=test-truststore.p12
export PEM_FILE_CERT=test-cert.pem
export PEM_FILE_KEY=test-key.pem
keySize=2048
days=10000
encryptionAlgo="aes-256-cbc"

# Certificate authority
openssl genrsa -out "testca.key" $keySize
openssl req -x509 -new -subj '/O=apache.org/OU=eng (NOT FOR PRODUCTION)/CN=testca' -key "testca.key" -nodes -out "testca.pem" -days $days -extensions v3_req
openssl req -new -subj '/O=apache.org/OU=eng (NOT FOR PRODUCTION)/CN=testca' -x509 -key "testca.key" -days $days -out "testca.crt"
openssl x509 -inform PEM -outform PEM -in "testca.crt" -out "testca.crt.pem"

echo "1"
#generate key
openssl genrsa -out "localhost.key" 2048
# Generate certificates
echo "2"
openssl req -new -subj "/O=apache.org/OU=eng (NOT FOR PRODUCTION)/CN=localhost" -key "localhost.key"  -out "localhost.csr"
echo "3"
openssl x509 -req -in "localhost.csr" -CA "testca.pem" -CAkey "testca.key" -CAcreateserial -days $days -out "${CERT_FILE}"
# Export keystores
echo "4"
openssl pkcs12 -export -in "${CERT_FILE}" -inkey "localhost.key" -certfile "testca.crt" -name "localhost" -out "${PKCS_FILE}" -passout pass:"${SECRET}" -keypbe "$encryptionAlgo" -certpbe $encryptionAlgo
# Truststore
echo "5"
keytool -keystore ${JKS_TRUST_FILE} -import -file ${CERT_FILE} -keypass ${SECRET} -storepass ${SECRET} -noprompt
echo "6"
keytool -importkeystore -srckeystore ${JKS_TRUST_FILE} -srcstorepass ${SECRET} -destkeystore ${PKCS_TRUST_FILE} -deststoretype PKCS12 -deststorepass ${SECRET}

rm -f *.crt *.jks *.pem *.key *.srl *.csr

#openssl pkcs12 -info -in test-keystore.p12  -noout





