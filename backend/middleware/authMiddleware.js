const { verifyAccessToken } = require("../utils/tokens");

function authMiddleware(req, res, next) {
  try {
    const auth = req.headers.authorization;
    if (!auth)
      return res.status(401).json({ message: "No authorization header" });
    const token = auth.split(" ")[1];
    const payload = verifyAccessToken(token);
    req.user = { id: payload.sub, email: payload.email };
    next();
  } catch (err) {
    return res.status(401).json({ message: "Invalid token" });
  }
}
module.exports = authMiddleware;
