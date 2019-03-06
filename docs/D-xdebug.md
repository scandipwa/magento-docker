# XDebug Setup and Usage

## Setup

php with xdebug is set for local by default, through $PHP_VERSION variable by appending `-debug` to docker image 
version.

### PhpStorm configuration

#### Browser Plugin

Install browser extensions to supply cookie for enabling debug - <https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions>

#### Debugger settings in IDE

Now to set the PhpStorm, go to:

_Preferences > Languages & Frameworks > PHP > Debug_

In this window chech the following settings:

*   Xdebug section, set port 9111
*   "Can accept external connections" is checked
*   "Ignore external connections through unregistered server configurations" is checked
*   Other settings is up to your preferences of the debugger

Now we need to set up a server configuration, to map local files to remote application container, head to:

_Languages & Frameworks > PHP > Debug > Servers__

*   Add new configuration by clicking the **+** symbol
*   Host: <localhost>
*   Port: 3001, which is default nginx port, try to avoid using varnish port and disable varnish in magento configuration during debug sessions
*   Debugger: Xdebug
*   And map your local `./src/` directory to remote `/var/www/public`

### Setting up IP alias

To allow connections from container to debug console in PhpStorm you need to add following alias to you system, this setting is **not** persisted between restarts, update your env accordingly

**Linux**

`sudo ip address add 172.254.254.254/24 dev docker0`

**macOS**

`sudo ifconfig en0 alias 172.254.254.254 255.255.255.0`

Now the configuration is complete, happy debugging!
