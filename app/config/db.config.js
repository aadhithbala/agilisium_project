module.exports = {
  HOST: "mysql_db",
  USER: "root",
  PASSWORD: "rmGQk5CHy2R7O8",
  DB: "todo_app_db",
  dialect: "mysql",
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
};
