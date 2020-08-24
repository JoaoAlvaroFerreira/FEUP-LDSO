# ktg-server

This is the **Know the Game** server source code.

The server is live on <http://104.248.19.12/>. API documentation also lives on the server, [here](http://104.248.19.12/api/v1/docs).

## Usage

The following commands should be run inside this directory.

### With Docker

Install [Docker Desktop](https://www.docker.com/products/docker-desktop) on your system.

Run

```shell
docker-compose up --build
```

The server will be open on `localhost:3000`.

To access the server container with Bash (for performing database migrations, etc.), run

```shell
# In another shell
docker exec -it server /bin/bash
```

To shut down the containers safely, do

```shell
# In another shell
docker-compose down
```

### Locally

#### Prerequisites

Install the following on your system:

- [Node.js](https://nodejs.org/en/)
- [PostgreSQL](https://www.postgresql.org/)
- [Redis](https://redis.io/)

#### For development

Get all JavaScript dependencies by running

```shell
npm install
```

Create a `ktg` role in your Postgres server with the password `ktg`.

You can do this with the `createuser` binary that ships with Postgres by running

```shell
createuser -sdW ktg
```

To create the databases, run

```shell
createdb ktg_dev; createdb ktg_test
# Conversely, use dropdb to delete

# Or
npx sequelize-cli db:create
npx sequelize-cli db:create --env test
```

The database will be created, but it will have no tables, you will need to manually run the migrations to insert existing tables. See the [migrations section](#migrations) on how to do this.

Finally, to run the server, run

```shell
npm run dev
```

## Database

The database name is `ktg_<env>`, where `env` is `dev`, `test` or `prod`, depending on the environment that the server is running, i.e., `dev` except on the production server, where it will be `prod`, and `test` when running tests.

### Changing the database

The database tables are defined as [Sequelize models](https://sequelize.org/master/manual/models-definition.html) in the `src/models/` folder. All changes to the database should be described with migration files. Read the [Sequelize manual page on migrations](https://sequelize.org/master/manual/migrations.html) for why and how to do this.

### Migrations

To integrate the current migrations into the database, run

```shell
npx sequelize-cli db:migrate
```

To undo all migrations, run

```shell
npx sequelize-cli db:migrate:undo:all
```

To undo and redo all migrations in one go, run

```shell
npm run migrate:reset
```

### Seeding (Optional)

Some dummy data can be loaded into the database via [seeds](https://sequelize.org/master/manual/migrations.html#creating-first-seed). To load this data: run

```shell
npx sequelize-cli db:seed:all
```

## Developing

### Linting and formatting

This project uses both [ESLint](https://eslint.org/) and [Prettier](https://prettier.io/) to enforce a code style. If you're using Visual Studio Code, install the ESLint plugin to see possible lint warnings.

To format the source code and eliminate (most) lint errors, run

```shell
npm run format
```

## Documentation

The API docs are automatically generated with [Swagger UI](https://swagger.io/tools/swagger-ui/). When the server is running, they're available on `/api/v1/docs`. They are generated from the [`docs.yaml`](src/docs.yaml) file. If you make any notable changes to the API, please make sure they are reflected in the documentation.

## Tests

This project uses the [Jest](https://jestjs.io/) testing framework, together with [Supertest](https://www.npmjs.com/package/supertest) to simulate HTTP requests to the API.

The test suites are all defined in the [`src/tests/`](/src/tests) folder.

To run the tests, run
```shell
npm test
```
