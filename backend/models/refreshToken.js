// models/refreshTokenModel.js
const pool = require("../config/db");

async function storeRefreshToken(userId, tokenHash, userAgent, ip, expiresAt) {
  await pool.query(
    "INSERT INTO refresh_tokens (user_id, token_hash, user_agent, ip, expires_at) VALUES (?, ?, ?, ?, ?)",
    [userId, tokenHash, userAgent, ip, expiresAt]
  );
}

async function findRefreshToken(tokenHash, userId) {
  const [rows] = await pool.query(
    "SELECT * FROM refresh_tokens WHERE token_hash = ? AND user_id = ?",
    [tokenHash, userId]
  );
  return rows[0];
}

async function deleteRefreshTokenById(id) {
  await pool.query("DELETE FROM refresh_tokens WHERE id = ?", [id]);
}

async function revokeRefreshToken(tokenHash) {
  await pool.query(
    "UPDATE refresh_tokens SET revoked = true WHERE token_hash = ?",
    [tokenHash]
  );
}

module.exports = {
  storeRefreshToken,
  findRefreshToken,
  deleteRefreshTokenById,
  revokeRefreshToken,
};
