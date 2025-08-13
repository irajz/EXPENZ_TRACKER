const { verifyAccessToken } = require("../utils/tokens");

function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    // 1. Ensure header exists
    if (!authHeader) {
      return res.status(401).json({ message: "Authorization header missing" });
    }

    // 2. Ensure it starts with 'Bearer'
    if (!authHeader.startsWith("Bearer ")) {
      return res
        .status(401)
        .json({
          message: "Invalid authorization format. Use 'Bearer <token>'",
        });
    }

    // 3. Extract token
    const token = authHeader.split(" ")[1].trim();
    if (!token) {
      return res
        .status(401)
        .json({ message: "Token missing from authorization header" });
    }

    // 4. Verify token
    const payload = verifyAccessToken(token);
    if (!payload) {
      return res.status(401).json({ message: "Invalid or expired token" });
    }

    // 5. Attach user data to request
    req.user = {
      id: payload.sub,
      email: payload.email,
    };

    next();
  } catch (err) {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
}

module.exports = authMiddleware;
