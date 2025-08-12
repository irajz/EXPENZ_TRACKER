const pool = require("../config/db");
const bcrypt = require("bcrypt");
const {
  signAccessToken,
  signRefreshToken,
  verifyRefreshToken,
} = require("../utils/tokens");
const crypto = require("crypto");

async function register(req, res) {
  const { email, password, name } = req.body;
  if (!email || !password)
    return res.status(400).json({ message: "Email and password required" });

  const [rows] = await pool.query("SELECT id FROM users WHERE email = ?", [
    email,
  ]);
  if (rows.length)
    return res.status(409).json({ message: "Email already registered" });

  const password_hash = await bcrypt.hash(password, 12);
  const [result] = await pool.query(
    "INSERT INTO users (email, password_hash, name) VALUES (?, ?, ?)",
    [email, password_hash, name || null]
  );
  const userId = result.insertId;
  res.status(201).json({ id: userId, email });
}

async function login(req, res) {
  const { email, password } = req.body;
  const [rows] = await pool.query(
    "SELECT id, password_hash FROM users WHERE email = ?",
    [email]
  );
  if (!rows.length)
    return res.status(401).json({ message: "Invalid credentials" });

  const user = rows[0];
  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) return res.status(401).json({ message: "Invalid credentials" });

  const accessToken = signAccessToken({ sub: user.id, email });
  const { token: refreshToken, jti } = signRefreshToken({
    sub: user.id,
    email,
  });

  // Store hashed refresh token in DB
  const token_hash = crypto
    .createHash("sha256")
    .update(refreshToken)
    .digest("hex");
  const expires_at = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // align with REFRESH_TOKEN_EXPIRES
  await pool.query(
    "INSERT INTO refresh_tokens (user_id, token_hash, user_agent, ip, expires_at) VALUES (?, ?, ?, ?, ?)",
    [user.id, token_hash, req.get("User-Agent") || null, req.ip, expires_at]
  );

  // send tokens: access in body, refresh as httpOnly secure cookie OR in body based on client
  res.cookie("refreshToken", refreshToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    maxAge: 7 * 24 * 3600 * 1000,
  });
  return res.json({ accessToken });
}

async function refresh(req, res) {
  // Expect refresh token in cookie
  const token = req.cookies?.refreshToken || req.body?.refreshToken;
  if (!token) return res.status(401).json({ message: "No token" });

  let payload;
  try {
    payload = verifyRefreshToken(token);
  } catch (err) {
    return res.status(401).json({ message: "Invalid token" });
  }

  const token_hash = crypto.createHash("sha256").update(token).digest("hex");
  const [rows] = await pool.query(
    "SELECT id, revoked, expires_at FROM refresh_tokens WHERE token_hash = ? AND user_id = ?",
    [token_hash, payload.sub]
  );
  if (!rows.length)
    return res.status(401).json({ message: "Token not recognized" });

  const dbToken = rows[0];
  if (dbToken.revoked || new Date(dbToken.expires_at) < new Date()) {
    return res.status(401).json({ message: "Token revoked or expired" });
  }

  // Rotate refresh token: delete old and insert new
  await pool.query("DELETE FROM refresh_tokens WHERE id = ?", [dbToken.id]);

  const { token: newRefresh, jti } = signRefreshToken({
    sub: payload.sub,
    email: payload.email,
  });
  const new_token_hash = crypto
    .createHash("sha256")
    .update(newRefresh)
    .digest("hex");
  const expires_at = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await pool.query(
    "INSERT INTO refresh_tokens (user_id, token_hash, user_agent, ip, expires_at) VALUES (?, ?, ?, ?, ?)",
    [
      payload.sub,
      new_token_hash,
      req.get("User-Agent") || null,
      req.ip,
      expires_at,
    ]
  );

  const newAccess = signAccessToken({ sub: payload.sub, email: payload.email });
  res.cookie("refreshToken", newRefresh, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    maxAge: 7 * 24 * 3600 * 1000,
  });
  return res.json({ accessToken: newAccess });
}

async function logout(req, res) {
  const token = req.cookies?.refreshToken || req.body?.refreshToken;
  if (token) {
    const token_hash = crypto.createHash("sha256").update(token).digest("hex");
    await pool.query(
      "UPDATE refresh_tokens SET revoked = true WHERE token_hash = ?",
      [token_hash]
    );
  }
  res.clearCookie("refreshToken");
  return res.json({ message: "Logged out" });
}

module.exports = { register, login, refresh, logout };
