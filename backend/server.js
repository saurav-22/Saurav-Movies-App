const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// MySQL connection (use RDS endpoint, replace placeholders)
const db = mysql.createConnection({
  host: 'movies-database.cuc9gqmx86tp.ap-south-1.rds.amazonaws.com', // e.g., ticketdb.xxxxx.us-east-1.rds.amazonaws.com
  user: 'admin',
  password: 'QazWsxEdc123##',
  database: 'ticketdb'
});

db.connect(err => {
  if (err) throw err;
  console.log('MySQL Connected');
});

// Get all movies
app.get('/movies', (req, res) => {
  db.query('SELECT * FROM movies', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Book tickets
app.post('/book', (req, res) => {
  const { movie_id, user_name, seats } = req.body;
  db.query('INSERT INTO bookings (movie_id, user_name, seats) VALUES (?, ?, ?)',
    [movie_id, user_name, seats],
    (err, results) => {
      if (err) throw err;
      res.json({ message: 'Booking successful', id: results.insertId });
    }
  );
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
