const pool = require("../config/db");

/**
 * Store a new refresh token
 * @param {number} userId - ID of the user
 * @param {string} token_hash - Hashed refresh token
 * @param {string} user_agent - Device/browser info
 * @param {string} ip - IP address of the request
 * @param {string} expires_at - Expiration datetime (ISO format)
 */
async function storeRefreshToken(
  userId,
  token_hash,
  user_agent,
  ip,
  expires_at
) {
  const sql = `
    INSERT INTO refreshtokens 
    (userID, token_hash, user_agent, ip, expires_at) 
    VALUES (?, ?, ?, ?, ?)
  `;
  return pool.query(sql, [userId, token_hash, user_agent, ip, expires_at]);
}

/**
 * Find a specific refresh token for a user
 * @param {string} token_hash - Hashed refresh token
 * @param {number} userId - ID of the user
 * @returns {Promise<object|null>}
 */
async function findRefreshToken(token_hash, userId) {
  const sql = `
    SELECT * 
    FROM refreshtokens 
    WHERE token_hash = ? AND userID = ?
  `;
  const [rows] = await pool.query(sql, [token_hash, userId]);
  return rows[0] || null;
}

/**
 * Delete a refresh token by its ID
 * @param {number} tokenId - Token ID
 */
async function deleteRefreshTokenById(tokenId) {
  return pool.query("DELETE FROM refreshtokens WHERE tokenID = ?", [tokenId]);
}

/**
 * Revoke a refresh token by setting 'revoked' to true
 * @param {string} token_hash - Hashed refresh token
 */
async function revokeRefreshToken(token_hash) {
  return pool.query(
    "UPDATE refreshtokens SET revoked = true WHERE token_hash = ?",
    [token_hash]
  );
}

module.exports = {
  storeRefreshToken,
  findRefreshToken,
  deleteRefreshTokenById,
  revokeRefreshToken,
};
