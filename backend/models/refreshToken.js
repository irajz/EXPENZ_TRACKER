const pool = require("../config/db");

async function storeRefreshToken(userId, tokenHash, userAgent, ip, expiresAt) {
  const sql = `INSERT INTO refresh_tokens 
    (user_id, token_hash, user_agent, ip, expires_at) VALUES (?, ?, ?, ?, ?)`;
  return pool.query(sql, [userId, tokenHash, userAgent, ip, expiresAt]);
}

async function findRefreshToken(tokenHash, userId) {
  const sql = `SELECT * FROM refresh_tokens WHERE token_hash = ? AND user_id = ?`;
  const [rows] = await pool.query(sql, [tokenHash, userId]);
  return rows[0];
}

async function deleteRefreshTokenById(id) {
  return pool.query("DELETE FROM refresh_tokens WHERE id = ?", [id]);
}

async function revokeRefreshToken(tokenHash) {
  return pool.query(
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
