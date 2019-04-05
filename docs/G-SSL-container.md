# SSL-term container

To make application working fully on local setup, and due to distributed nature, we need to use valid self-signed certificate from trusted Certificate Authority.

Service Worker works only on https with valid certificate (green lock in address bar) or localhost.
Warning about untrusted certificate counts as untrusted, so generating and trusting certificate in browser does not work.

## Certificate generator

To generate certificates, run `make cert` from project root path.
To refresh SSL certificate, rerun the `make cert`, it will remove existing server certificates and generates new ones.

There is a script in `./deploy/create_certificates.sh` which guides you through CA and certificate generation process. Aimed to executed inside Alpine Linux container.

By default it will store all files in `/opt/cert` at project base path.

## What's inside

`ssl-term` container is a dropin container, that is meant to be used in _development environment only_.
It overrides nginx configs to provide:

-   correct traffic routing
-   SSL termination
-   SSL certificates

Out of the box there are self-signed certificates to serve encrypted traffic from 

-   `localhost`
-   `*.local`
-   `scandipwa.local`
-   `127.0.0.1`
-   `*.dev`
-   `scandipwa.dev`

Keep in mind you must add corresponding records to your `/etc/hosts` yourself.

## Self-signed root CA installation

 It is a _one time per machine_ action, that is required to allow browsers to treat any certificate, generated with 
 the root CA to be treated as valid.

### MacOS

You might be prompted for an admin password for a few times during this steps:  
1\. Add certificate `opt/cert/scandipwa-ca.pem` to your `Keychain`  
2\. Double click on `ScandiPWA CA`  
3\. Unfold `Trust` section  
4\. Set _When using this certificate_ -> **Always trust**  
5\. Restart you machine  
6\. Add one more file (`-f docker-compose.ssl.yml`) to you docker-compose command  

### Firefox

Additionally to default import set `security.enterprise_roots.enabled` to **true** in the `about:config` 
