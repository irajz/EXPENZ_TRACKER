const pool = require("../config/db");
const ms = require("ms");
const bcrypt = require("bcrypt");
const crypto = require("crypto");
const {
  signAccessToken,
  signRefreshToken,
  verifyRefreshToken,
} = require("../utils/tokens");
const refreshTokenModel = require("../models/refreshToken");

// Read expiry times from .env in human-readable format
const REFRESH_TOKEN_EXPIRES = process.env.REFRESH_TOKEN_EXPIRES || "7d";
const ACCESS_TOKEN_EXPIRES = process.env.ACCESS_TOKEN_EXPIRES || "15m";
const REFRESH_TOKEN_EXPIRES_MS = ms(REFRESH_TOKEN_EXPIRES);
const ACCESS_TOKEN_EXPIRES_MS = ms(ACCESS_TOKEN_EXPIRES);

async function register(req, res) {
  try {
    const { email, password, name } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: "Email and password required" });
    }

    const [rows] = await pool.query("SELECT id FROM users WHERE email = ?", [
      email,
    ]);
    if (rows.length) {
      return res.status(409).json({ message: "Email already registered" });
    }

    const password_hash = await bcrypt.hash(password, 12);
    const [result] = await pool.query(
      "INSERT INTO users (email, pwd, name) VALUES (?, ?, ?)",
      [email, password_hash, name || null]
    );

    res.status(201).json({ id: result.insertId, email });
  } catch (error) {
    console.error("Register error:", error);
    res.status(500).json({ message: "Server error during registration" });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: "Email and password required" });
    }

    const [rows] = await pool.query(
      "SELECT id, pwd FROM users WHERE email = ?",
      [email]
    );

    if (!rows.length) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const user = rows[0];
    const valid = await bcrypt.compare(password, user.pwd);
    if (!valid) return res.status(401).json({ message: "Invalid credentials" });

    const accessToken = signAccessToken(
      { sub: user.id, email },
      ACCESS_TOKEN_EXPIRES
    );
    const { token: refreshToken } = signRefreshToken(
      { sub: user.id, email },
      REFRESH_TOKEN_EXPIRES
    );

    const token_hash = crypto
      .createHash("sha256")
      .update(refreshToken)
      .digest("hex");
    const expires_at = new Date(Date.now() + REFRESH_TOKEN_EXPIRES_MS);

    await refreshTokenModel.storeRefreshToken(
      user.id,
      token_hash,
      req.get("User-Agent") || null,
      req.ip,
      expires_at
    );

    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: REFRESH_TOKEN_EXPIRES_MS,
    });

    return res.json({ accessToken });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ message: "Server error during login" });
  }
}

async function refresh(req, res) {
  try {
    const token = req.cookies?.refreshToken || req.body?.refreshToken;
    if (!token) return res.status(401).json({ message: "No token provided" });

    let payload;
    try {
      payload = verifyRefreshToken(token);
    } catch (err) {
      console.error("Refresh verify error:", err.message);
      return res.status(401).json({ message: "Invalid refresh token" });
    }

    const token_hash = crypto.createHash("sha256").update(token).digest("hex");
    const dbToken = await refreshTokenModel.findRefreshToken(
      token_hash,
      payload.sub
    );

    if (!dbToken)
      return res.status(401).json({ message: "Token not recognized" });
    if (dbToken.revoked || new Date(dbToken.expires_at) < new Date()) {
      return res.status(401).json({ message: "Token revoked or expired" });
    }

    // Rotate refresh token
    await refreshTokenModel.deleteRefreshTokenById(dbToken.id);

    const { token: newRefresh } = signRefreshToken(
      { sub: payload.sub, email: payload.email },
      REFRESH_TOKEN_EXPIRES
    );

    const new_token_hash = crypto
      .createHash("sha256")
      .update(newRefresh)
      .digest("hex");
    const expires_at = new Date(Date.now() + REFRESH_TOKEN_EXPIRES_MS);

    await refreshTokenModel.storeRefreshToken(
      payload.sub,
      new_token_hash,
      req.get("User-Agent") || null,
      req.ip,
      expires_at
    );

    const newAccess = signAccessToken(
      { sub: payload.sub, email: payload.email },
      ACCESS_TOKEN_EXPIRES
    );

    res.cookie("refreshToken", newRefresh, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: REFRESH_TOKEN_EXPIRES_MS,
    });

    return res.json({ accessToken: newAccess });
  } catch (error) {
    console.error("Refresh token error:", error);
    res.status(500).json({ message: "Server error during token refresh" });
  }
}

async function logout(req, res) {
  try {
    const token = req.cookies?.refreshToken || req.body?.refreshToken;
    if (token) {
      const token_hash = crypto
        .createHash("sha256")
        .update(token)
        .digest("hex");
      await refreshTokenModel.revokeRefreshToken(token_hash);
    }

    res.clearCookie("refreshToken");
    return res.json({ message: "Logged out" });
  } catch (error) {
    console.error("Logout error:", error);
    res.status(500).json({ message: "Server error during logout" });
  }
}

module.exports = { register, login, refresh, logout };
