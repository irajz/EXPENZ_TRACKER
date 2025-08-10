const express = require("express");
const mysql = require("mysql2");

const app = express();
app.use(express.json());

// MySQL connection setup
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "", // change if you set a password in XAMPP
  database: "expenz_db",
});

db.connect((err) => {
  if (err) {
    console.error("MySQL connection error:", err);
    return;
  }
  console.log("Connected to MySQL!");
});

// Sample route to test
app.get("/", (req, res) => {
  res.send("Backend is working!");
});

const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
