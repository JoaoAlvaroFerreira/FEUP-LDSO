# Know the Game

#### `master` status

[![pipeline status](https://gitlab.com/feup-tbs/ldso1920/t1g3/badges/master/pipeline.svg)](https://gitlab.com/feup-tbs/ldso1920/t1g3/commits/master)
[![coverage report](https://gitlab.com/feup-tbs/ldso1920/t1g3/badges/master/coverage.svg)](https://gitlab.com/feup-tbs/ldso1920/t1g3/commits/master)

#### `develop` status

[![pipeline status](https://gitlab.com/feup-tbs/ldso1920/t1g3/badges/develop/pipeline.svg)](https://gitlab.com/feup-tbs/ldso1920/t1g3/commits/develop)
[![coverage report](https://gitlab.com/feup-tbs/ldso1920/t1g3/badges/develop/coverage.svg)](https://gitlab.com/feup-tbs/ldso1920/t1g3/commits/develop)

**Know the Game** is a friendly sports betting app.

The project follows a typical client-server architecture. For extensive details see the [project Wiki](https://gitlab.com/feup-tbs/ldso1920/t1g3/wikis/home).

## Client

The client is the project frontend, a mobile app written in [Dart](https://dart.dev/) using the [Flutter framework](https://flutter.dev/). The client consumes data from the API, parses it and displays it to the user on the graphical user interface.

See the [client README](/client/README.md) for more details.

### Releases

See the [releases page](https://gitlab.com/feup-tbs/ldso1920/t1g3/releases) for downloading past app releases.

## Server

The server is the project backend, it consists of a [Node.js](https://nodejs.org/en/) web server built with the [Express library](https://expressjs.com/) that aims to provide an API for the client to consume. The server connects to a [PostgreSQL](https://www.postgresql.org/) database, and interfaces with it via the [Sequelize ORM](https://sequelize.org/).

See the [server README](/server/README.md) for more details.

### Production and staging

The production server is live on <http://104.248.19.12/> ([docs](http://104.248.19.12/api/v1/docs)).

The staging server is live on <http://104.248.19.12:5050/> ([docs](http://104.248.19.12:5050/api/v1/docs)).

## Developing

All contributors should adhere to the guidelines detailed in the [CONTRIBUTING](/CONTRIBUTING.md) file. Further guidelines are stated in the respective README files for the client and server projects, when applicable.
