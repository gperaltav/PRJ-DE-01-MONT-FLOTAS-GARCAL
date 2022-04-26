module.exports = {
    HOST: "34.143.233.232",
    USER: "postgres",
    PASSWORD: "postgres",
    DB: "garcal-db-test",
    dialect: "postgres",
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  };