const db = require("../db");

const createTransaction = (
  userID,
  type,
  category,
  title,
  description,
  amount,
  date,
  time,
  callback
) => {
  const sql = `INSERT INTO transactions 
    (userID, type, category, title, description, amount, date, time) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

  db.query(
    sql,
    [userID, type, category, title, description, amount, date, time],
    callback
  );
};

const getUserTransactions = (userID, callback) => {
  const sql =
    "SELECT * FROM transactions WHERE userID = ? ORDER BY date DESC, time DESC";

  db.query(sql, [userID], callback);
};

module.exports = { createTransaction, getUserTransactions };
