const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

// ---------------- DB connection ----------------
const db = mysql.createConnection({
  host: "localhost",
  user: "root",   // change if you set a password
  password: "",   // add password if your MySQL has one
  database: "energy_trading"
});

db.connect(err => {
  if (err) {
    console.error("❌ MySQL connection failed:", err);
    process.exit(1);
  }
  console.log("✅ MySQL connected");
});

// ---------------- API Routes ----------------

// Add listing (from seller)
app.post("/addListing", (req, res) => {
  const { seller, kwh, price } = req.body;
  if (!seller || !kwh || !price) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  db.query(
    "INSERT INTO listings (seller_name, kwh, price) VALUES (?, ?, ?)",
    [seller, kwh, price],
    (err, result) => {
      if (err) {
        console.error("❌ Error inserting listing:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json({ success: true, id: result.insertId });
    }
  );
});

// Get all listings (for buyer)
app.get("/listings", (req, res) => {
  db.query(
    "SELECT * FROM listings WHERE status='Available'",
    (err, results) => {
      if (err) {
        console.error("❌ Error fetching listings:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    }
  );
});

// Optional: Buy energy (update listing status to Sold)
app.post("/buy", (req, res) => {
  const { id } = req.body;
  if (!id) return res.status(400).json({ error: "Missing listing ID" });

  db.query(
    "UPDATE listings SET status='Sold' WHERE id=?",
    [id],
    (err, result) => {
      if (err) {
        console.error("❌ Error updating listing:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json({ success: true, message: "Listing marked as Sold" });
    }
  );
});

// ---------------- Start Server ----------------
const PORT = 4000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
