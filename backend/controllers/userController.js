const bcrypt = require("bcrypt");
const User = require("../models/user");

const createUser = async (req, res) => {
  try {
    const { name, email, pwd } = req.body;

    if (!name || !email || !pwd) {
      return res
        .status(400)
        .json({ message: "Name, email and password are required" });
    }

    const hashedPassword = await bcrypt.hash(pwd, 10);

    User.createUser(name, email, hashedPassword, (err, result) => {
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
  User.getUsers((err, results) => {
    if (err) {
      return res.status(500).json({ message: err.message });
    }
    res.json(results);
  });
};

module.exports = { createUser, getUsers };
