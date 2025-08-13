const pool = require("../config/db");

/**
 * Store a new refresh token
 * @param {number} userId - ID of the user
 * @param {string} tokenHash - Hashed refresh token
 * @param {string} userAgent - Device/browser info
 * @param {string} ip - IP address of the request
 * @param {string} expiresAt - Expiration datetime (ISO format)
 */
async function storeRefreshToken(userId, tokenHash, userAgent, ip, expiresAt) {
  const sql = `
    INSERT INTO refresh_tokens 
    (userID, token_hash, user_agent, ip, expires_at) 
    VALUES (?, ?, ?, ?, ?)
  `;
  return pool.query(sql, [userId, tokenHash, userAgent, ip, expiresAt]);
}

/**
 * Find a specific refresh token for a user
 * @param {string} tokenHash - Hashed refresh token
 * @param {number} userId - ID of the user
 * @returns {Promise<object|null>}
 */
async function findRefreshToken(tokenHash, userId) {
  const sql = `
    SELECT * 
    FROM refresh_tokens 
    WHERE token_hash = ? AND userID = ?
  `;
  const [rows] = await pool.query(sql, [tokenHash, userId]);
  return rows[0] || null;
}

/**
 * Delete a refresh token by its ID
 * @param {number} tokenId - Token ID
 */
async function deleteRefreshTokenById(tokenId) {
  return pool.query("DELETE FROM refresh_tokens WHERE tokenID = ?", [tokenId]);
}

/**
 * Revoke a refresh token by setting 'revoked' to true
 * @param {string} tokenHash - Hashed refresh token
 */
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
