#!/usr/bin/env bash

# openssl req \
#   -newkey rsa:2048 \
#   -x509 \
#   -nodes \
#   -keyout local.key \
#   -new \
#   -out local.crt \
#   -subj /CN=*.local \
#   -reqexts SAN \
#   -extensions SAN \
#   -config <(cat openssl.cnf \
#       <(printf '[SAN]\nsubjectAltName=DNS:hostname,IP:192.168.0.1')) \
#   -sha256 \
#   -days 3650
  
  # # Generate CSR for new cert
  # openssl req \
  # -new \
  # -out local.csr \
  # -key local.key \
  # -subj /CN=scandipwa.local \
  # -reqexts SAN \
  # -extensions SAN \
  # -config <(cat openssl.cnf \
  #       <(printf '[SAN]\nsubjectAltName=DNS:scandipwa.local,IP:127.0.0.1')) \
  # 
  # # Sign cert with CA
  # openssl x509 \
  # -req \
  # -in local.csr \
  # -CA rootCA.pem \
  # -CAkey ../../../opt/rootCA.key \
  # -CAcreateserial \
  # -out local.crt \
  # -days 3650 \
  # -sha256

# Generating ROOT CA key and cert
openssl genrsa -des3 -out ../../../opt/rootCA.key 4096

openssl req -x509 -new -nodes -key ../../../opt/rootCA.key -sha256 -days 1024 -out rootCA.crt

rm -f local.*

openssl genrsa -out local.key 2048

openssl req -new \
    -key local.key \
    -config certificate.conf \
    -out local.csr
    
openssl req -in local.csr -noout -text

openssl x509 -req -in local.csr -CA rootCA.pem -CAkey ../../../opt/rootCA.key -CAcreateserial -out local.crt -days 3650 -sha256 -extfile certificate.conf -extensions req_ext

openssl x509 -in local.crt -text -noout