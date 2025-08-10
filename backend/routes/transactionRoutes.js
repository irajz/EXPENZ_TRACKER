const express = require("express");
const router = express.Router();

const transactionController = require("../controllers/transactionController");

// Route to create a new transaction
router.post("/transactions", transactionController.createTransaction);

// Route to get transactions by userID
router.get("/transactions/:userID", transactionController.getUserTransactions);

module.exports = router;
