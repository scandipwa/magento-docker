![ScandiPWA_logo](https://i.imgur.com/SLtCyQ8.png)

***

<!-- [![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/scandipwa/base.svg)](https://hub.docker.com/r/scandipwa/base) -->
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d90631c26cab4c459180a57a2b1268dc)](https://www.codacy.com/app/ScandiPWA/scandipwa-base?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=scandipwa/scandipwa-base&amp;utm_campaign=Badge_Grade)
[![Explore documentation](https://img.shields.io/badge/explore-documentation-orange)](https://docs.scandipwa.com/)
[![Join community Slack](https://img.shields.io/badge/join-community%20slack-brightgreen)](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk)

This is a base repository that contains the Docker environment for Magento ^2.3.

Scandipwa-base is a docker environment that is needed for the development of the ScandiPWA theme.

>**Already installed ScandiPWA?** Then go to the [scandipwa/base-theme](https://github.com/scandipwa/base-theme) repository to check the latest releases! 

## What is ScandiPWA?

ScandiPWA is a single page application (SPA) theme for Magento with advanced PWA capabilities.

ScandiPWA is based on React and utilizes GraphQL API of Magento 2.3.

**SEE IT IN ACTION** → demo.scandipwa.com

### Want to learn more?

See what we have for you:
- [Video Tutorials](https://www.youtube.com/playlist?list=PLy0PoJ53Gjy3iHQmsZCD1WAazhyS03l-y)
- [Weekly webinars](https://www.youtube.com/channel/UCvnxo7rh5NRwvMHtJga9fww/videos)
- [ScandiPWA Documentation](https://docs.scandipwa.com/)
- [FAQ Page](https://docs.scandipwa.com/docs/installation/faq/)

**Your question was not covered?**
Join our community [Slack channel](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk) and ask the core team directly! 

## Docker Setup

The docker environment is prepared to deploy and develop the theme.
We recommend using it as:

- It has pre-configured services
- No need to have an existing Magento installation
- Rendertrone out of the box
- It has a development-friendly setup

>**NOTE!** Currently, the docker setup is supported only for Linux.

### Ready to try?

Follow the guide for [Docker setup on Linux](https://docs.scandipwa.com/docs/installation/docker/linux/) or watch the video guide.

[![docker install](https://i.ibb.co/0MpPFXL/Group-5.png)](https://www.youtube.com/watch?v=IOXSBcCBvCw&list=PLy0PoJ53Gjy3iHQmsZCD1WAazhyS03l-y&index=1)

## Setup on existing Magento

Already have an existing Magento installation? 

ScandiPWA is a regular Magento theme. You can install it on the existing Magento instance using composer.

### Ready to try?

Follow the guide for [setup on existing Magento](https://docs.scandipwa.com/docs/installation/on-existing-m2/) or watch the video guide.

[![existing M2 setup](https://i.ibb.co/1Xc12Pd/Group-8.png)](https://www.youtube.com/watch?v=JfvC3PcaHPU&list=PLy0PoJ53Gjy3iHQmsZCD1WAazhyS03l-y&index=2)

## Setup with a remote server

If you are not planning to developer a back-end functionality, but to modify the front-end only, you can try setting up the theme with the remote Magento 2 server.

> **NOTE!** It is impossible to test the website in production mode (of the webpack build). This is the main downside of this approach.

### Ready to try?

Follow the guide for [setup with remote M2 server](https://docs.scandipwa.com/docs/installation/with-remote-m2/).

## Modularity

The repository is based on Magento 2.3. All components and modules, except the further theme development must be managed by [Composer](https://getcomposer.org).

## Dependencies

- [scandipwa/installer](https://github.com/scandipwa/installer)
- [scandipwa/source](https://github.com/scandipwa/base-theme)
- [scandipwa/graphql](https://github.com/scandipwa/graphql)
- [scandipwa/catalog-graphql](https://github.com/scandipwa/catalog-graphql)
- [scandipwa/cms-graphql](https://github.com/scandipwa/cms-graphql)
- [scandipwa/menu-organizer](https://github.com/scandipwa/menu-organizer)
- [scandipwa/persisted-query](https://github.com/scandipwa/persisted-query)
- [scandipwa/slider-graphql](https://github.com/scandipwa/slider-graphql)
- [scandipwa/slider](https://github.com/scandipwa/slider)
- [scandipwa/route171](https://github.com/scandipwa/route717)
- [scandiweb/module-core](https://github.com/scandiwebcom/Scandiweb-Assets-Core)

## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fscandipwa%2Fscandipwa-base.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fscandipwa%2Fscandipwa-base?ref=badge_large)
