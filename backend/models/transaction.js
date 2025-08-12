const pool = require("../config/db"); // assumes promise-enabled pool

async function createTransaction(
  userID,
  type,
  category,
  title,
  description,
  amount,
  date,
  time
) {
  const sql = `INSERT INTO transactions 
    (userID, type, category, title, description, amount, date, time) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

  const [result] = await pool.query(sql, [
    userID,
    type,
    category,
    title,
    description || null,
    amount,
    date,
    time,
  ]);
  return result;
}

async function getUserTransactions(userID) {
  const sql =
    "SELECT * FROM transactions WHERE userID = ? ORDER BY date DESC, time DESC";
  const [rows] = await pool.query(sql, [userID]);
  return rows;
}

module.exports = { createTransaction, getUserTransactions };
