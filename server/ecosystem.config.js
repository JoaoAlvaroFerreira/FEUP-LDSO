module.exports = {
  apps: [
    {
      name: "ktg_api",
      script: "npm",
      args: "start",
      append_env_to_name: true,
      env: {
        PORT: 3001,
        NODE_ENV: "development"
      },
      env_production: {
        PORT: 3000,
        NODE_ENV: "production"
      }
    }
  ]
};
