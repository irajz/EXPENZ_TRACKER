const db = require("../db");

const createUser = (name, email, hashedPassword, callback) => {
  const sql = "INSERT INTO users (name, email, pwd) VALUES (?, ?, ?)";
  db.query(sql, [name, email, hashedPassword], callback);
};

const getUsers = (callback) => {
  const sql = "SELECT userID, name, email, created_at FROM users";
  db.query(sql, callback);
};

module.exports = { createUser, getUsers };
