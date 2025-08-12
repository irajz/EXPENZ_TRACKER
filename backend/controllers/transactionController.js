const Transaction = require("../models/transaction");

const createTransaction = async (req, res) => {
  try {
    const { userID, type, category, title, description, amount, date, time } =
      req.body;

    // Basic validation
    if (
      !userID ||
      (type !== 0 && type !== 1) ||
      !category ||
      !title ||
      amount == null || // allows 0 but disallows null/undefined
      !date ||
      !time
    ) {
      return res
        .status(400)
        .json({ message: "Missing required fields or invalid type" });
    }

    const result = await Transaction.createTransaction(
      userID,
      type,
      category,
      title,
      description,
      amount,
      date,
      time
    );

    res.status(201).json({ transactionID: result.insertId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

const getUserTransactions = async (req, res) => {
  try {
    const userID = req.params.userID;
    if (!userID) {
      return res.status(400).json({ message: "Missing userID parameter" });
    }

    const transactions = await Transaction.getUserTransactions(userID);
    res.json(transactions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { createTransaction, getUserTransactions };
