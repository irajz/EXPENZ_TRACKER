const pool = require("../config/db"); // assume pool.promise() exported

async function createUser(name, email, pwd) {
  const sql = "INSERT INTO users (name, email, pwd) VALUES (?, ?, ?)";
  const [result] = await pool.query(sql, [name, email, pwd]);
  return result;
}

async function getUsers() {
  const sql = "SELECT userID, name, email, created_at FROM users";
  const [rows] = await pool.query(sql);
  return rows;
}

module.exports = { createUser, getUsers };
