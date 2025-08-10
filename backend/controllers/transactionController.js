const Transaction = require("../models/transaction");

const createTransaction = (req, res) => {
  const { userID, type, category, title, description, amount, date, time } =
    req.body;

  if (
    !userID ||
    (type !== 0 && type !== 1) ||
    !category ||
    !title ||
    !amount ||
    !date ||
    !time
  ) {
    return res
      .status(400)
      .json({ message: "Missing required fields or invalid type" });
  }

  Transaction.createTransaction(
    userID,
    type,
    category,
    title,
    description,
    amount,
    date,
    time,
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: err.message });
      }
      res.status(201).json({ transactionID: result.insertId });
    }
  );
};

const getUserTransactions = (req, res) => {
  const userID = req.params.userID;

  Transaction.getUserTransactions(userID, (err, results) => {
    if (err) {
      return res.status(500).json({ message: err.message });
    }
    res.json(results);
  });
};

module.exports = { createTransaction, getUserTransactions };
