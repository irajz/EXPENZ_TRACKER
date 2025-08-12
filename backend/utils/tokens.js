const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");

function signAccessToken(payload) {
  return jwt.sign(payload, process.env.ACCESS_TOKEN_SECRET, {
    expiresIn: process.env.ACCESS_TOKEN_EXPIRES || "15m",
  });
}
function signRefreshToken(payload) {
  // include a token id (jti) so we can rotate/identify
  const jti = uuidv4();
  return {
    token: jwt.sign({ ...payload, jti }, process.env.REFRESH_TOKEN_SECRET, {
      expiresIn: process.env.REFRESH_TOKEN_EXPIRES || "24h",
    }),
    jti,
  };
}
function verifyAccessToken(token) {
  return jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
}
function verifyRefreshToken(token) {
  return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
}
module.exports = {
  signAccessToken,
  signRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
};
