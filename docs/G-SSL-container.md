# SSL-term container

At one point `localhost` is not good enough location for you application,
but at the same time, in order to make serviceworker running, you are 
forced to use HTTPS protocol.

## What's inside
`SSL-term` container is a pluggable container, that is meant to be used in *development environment only*.
It overrides nginx configs to provide:
- correct traffic routing
- SSL termination
- SSL certificates

Out of the box there are self-signed certificates to serve encrypted traffic from `https://scandipwa.local` domain.
Keep in mind you must add this domain to your `/etc/hosts` yourself.
 
## Self-signed root CA installation
 It is a *one time per machine* action, that is required to allow browsers to treat any certificate, generated with 
 the root CA to be treated as valid.


### MacOS
You might be prompted for an admin password for a few times during this steps: 
1. Add certificate `deploy/local/cert/rootCA.pem` to your `Keychain`
2. Double click on `PWA root CA`
3. Unfold `Trust` section
4. Set *When using this certificate* -> **Always trust**
5. Restart you machine
6. Add one more file (`-f docker-compose.ssl.yml`) to you docker-compose command

## Advanced
It is also possible to generate certificates for other domains, 
however, it raises some security concerns, so this topic will be covered later.
