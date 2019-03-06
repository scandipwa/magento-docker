# Development environment

ScandiPWA team had to reach few goals. The first one, obvious, create an awesome PWA providing new experience to the 
e-commerce platform.
The second - create a convenient development environment and customization possibilities. For this reason repository 
starts with Docker docs, that provides pre-configured environment suitable for both - development and testing as well
 as production-like environment.
 
 ## Local filesystem mounting
 `docker-compose.local.yml` provides basic FS mounting for convenient development. Source code is always yours!
 
 ## Additional services
 
 ### Frontend service
 Frontend service provides a convenient way of customizing and working on ScandiPWA theme.
Service itself is running a Webpack dev-server with autocompile and autoreload. For more details please refer to 
[Frontend-container](./F-Frontend-container.md)

### SSL-term
Service workers can be runned only on `localhost` or hosts running under HTTPS protocol with a valid SSL certificate.
 To make it easier for developers to get up and running with it - `ssl-term` can be plugged independantly to any set 
 of containers. For more details please refer to [SSL-container](G-SSL-container.md)
