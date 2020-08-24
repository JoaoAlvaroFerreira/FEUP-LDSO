module.exports = {
  development: {
    username: process.env.POSTGRES_USER || "ktg",
    password: process.env.POSTGRES_PASSWORD || "ktg",
    database: process.env.POSTGRES_DB || "ktg_dev",
    host: process.env.POSTGRES_HOST || "127.0.0.1",
    dialect: "postgres"
  },
  test: {
    username: process.env.POSTGRES_USER || "ktg",
    password: process.env.POSTGRES_PASSWORD || "ktg",
    database: process.env.POSTGRES_DB || "ktg_test",
    host: process.env.POSTGRES_HOST || "127.0.0.1",
    dialect: "postgres",
    logging: false
  },
  production: {
    username: process.env.POSTGRES_USER || "ktg",
    password: process.env.POSTGRES_PASSWORD || "ktg",
    database: process.env.POSTGRES_DB || "ktg_prod",
    host: process.env.POSTGRES_HOST || "127.0.0.1",
    dialect: "postgres",
    logging: false
  }
};
