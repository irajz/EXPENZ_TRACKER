const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const ms = require("ms");

// Load env values with defaults & validation
const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET;
const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET;

if (!ACCESS_TOKEN_SECRET || !REFRESH_TOKEN_SECRET) {
  throw new Error("JWT secrets are missing in environment variables");
}

const ACCESS_TOKEN_EXPIRES = process.env.ACCESS_TOKEN_EXPIRES || "15m";
const REFRESH_TOKEN_EXPIRES = process.env.REFRESH_TOKEN_EXPIRES || "7d"; // default 7 days

/**
 * Sign Access Token
 * @param {Object} payload - JWT payload
 * @returns {String} - Signed access token
 */
function signAccessToken(payload) {
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, {
    expiresIn: ACCESS_TOKEN_EXPIRES,
  });
}

/**
 * Sign Refresh Token with JTI (token ID)
 * @param {Object} payload - JWT payload
 * @returns {Object} - { token, jti, expiresAt }
 */
function signRefreshToken(payload) {
  const jti = uuidv4();
  const expiresInMs = ms(REFRESH_TOKEN_EXPIRES);

  return {
    token: jwt.sign({ ...payload, jti }, REFRESH_TOKEN_SECRET, {
      expiresIn: REFRESH_TOKEN_EXPIRES,
    }),
    jti,
    expiresAt: new Date(Date.now() + expiresInMs), // for DB storage
  };
}

/**
 * Verify Access Token
 * @param {String} token
 * @returns {Object} - Decoded payload
 */
function verifyAccessToken(token) {
  return jwt.verify(token, ACCESS_TOKEN_SECRET);
}

/**
 * Verify Refresh Token
 * @param {String} token
 * @returns {Object} - Decoded payload
 */
function verifyRefreshToken(token) {
  return jwt.verify(token, REFRESH_TOKEN_SECRET);
}

module.exports = {
  signAccessToken,
  signRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
};
