![ScandiPWA_logo](https://i.imgur.com/SLtCyQ8.png)

***

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/scandipwa/base.svg)](https://hub.docker.com/r/scandipwa/base)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d90631c26cab4c459180a57a2b1268dc)](https://www.codacy.com/app/ScandiPWA/scandipwa-base?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=scandipwa/scandipwa-base&amp;utm_campaign=Badge_Grade)

This is a base repository that contains Docker environment for Magento ^2.3.

ScandiPWA-base is needed for the ScandiPWA theme installation for further development. 

>**Already installed ScandiPWA?** Then go to the [scandipwa/base-theme](https://github.com/scandipwa/base-theme) repository to check the latest changes! 

## What is ScandiPWA?

ScandiPWA is a single page application (SPA) theme for Magento with advanced PWA capabilities. 

ScandiPWA is based on React and utilizes GraphQL API of Magento 2.3.

**SEE IT IN ACTION** → demo.scandipwa.com

### Want to learn more? 

See what we have for you:
- [Video Guides & Weekly Webinars](https://www.youtube.com/channel/UCvnxo7rh5NRwvMHtJga9fww)
- [ScandiPWA User Guide](https://scandiweb.atlassian.net/wiki/spaces/SUG/overview)
- [ScandiPWA Documentation](https://docs.scandipwa.com/#/)

**Your question was not covered?**
Join our community [Slack channel](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk) and ask the core team directly! 

## Docker Setup

The docker environment is prepared to deploy and develop theme.
We reccomend using it as has:

- Pre-configured services 
- No need to have an existing Magento installation
- Rendertrone out of the box
- Development-friendly setup

Lean more about [Docker template for ScandiPWA](https://github.com/scandipwa/scandipwa-base/blob/2.x-stable/DOCKER.md).

### Ready to try?

Follow the guide for [Docker setup on Linux](https://docs.scandipwa.com/#/setup/docker/linux) or watch the [video guide]().
 
## Setup on existing Magento

Already have an existing Magento installation? ScandiPWA is a regular Magento theme. We can install it on existing Magento instance using composer.

### Ready to try?

Follow the guide for [setup on existing Magento](https://docs.scandipwa.com/#/setup/on-existing-m2) or watch the [video guide]().

## Setup with remote server

If you are planning to developer a back-end functionality, but to modify the front-end only, can can try setting up the theme with remote Magento 2 server.

> **NOTE!** it is impossible to test the website in production mode (of the webpack build). This is the main downside of this approach.

### Ready to try?

Follow the guide for [setup with remote server](https://docs.scandipwa.com/#/setup/with-remote-m2) or watch the [video guide]().

## Modularity
The repository is based on Magento 2.3. All components and modules, except the further theme development must be 
managed by [Composer](https://getcomposer.org).

## Dependencies
-   [scandipwa/installer](https://github.com/scandipwa/installer)
-   [scandipwa/source](https://github.com/scandipwa/base-theme)
-   [scandipwa/graphql](https://github.com/scandipwa/graphql)
-   [scandipwa/catalog-graphql](https://github.com/scandipwa/catalog-graphql)
-   [scandipwa/cms-graphql](https://github.com/scandipwa/cms-graphql)
-   [scandipwa/menu-organizer](https://github.com/scandipwa/menu-organizer)
-   [scandipwa/persisted-query](https://github.com/scandipwa/persisted-query)
-   [scandipwa/slider-graphql](https://github.com/scandipwa/slider-graphql)
-   [scandipwa/slider](https://github.com/scandipwa/slider)
-   [scandipwa/route171](https://github.com/scandipwa/route717)
-   [scandiweb/module-core](https://github.com/scandiwebcom/Scandiweb-Assets-Core)

## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fscandipwa%2Fscandipwa-base.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fscandipwa%2Fscandipwa-base?ref=badge_large)
