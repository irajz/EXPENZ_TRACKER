const db = require("../db");
const bcrypt = require("bcrypt");

const createUser = async (req, res) => {
  try {
    const { email, pwd } = req.body;

    if (!email || !pwd) {
      return res
        .status(400)
        .json({ message: "Email and password are required" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(pwd, 10);

    const sql = "INSERT INTO user (email, pwd) VALUES (?, ?)";
    db.query(sql, [email, hashedPassword], (err, result) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(409).json({ message: "Email already exists" });
        }
        return res.status(500).json({ message: err.message });
      }
      res.status(201).json({ userID: result.insertId, email });
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getUsers = (req, res) => {
  const sql = "SELECT userID, email, created_at FROM user";
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ message: err.message });
    }
    res.json(results);
  });
};

module.exports = { createUser, getUsers };
