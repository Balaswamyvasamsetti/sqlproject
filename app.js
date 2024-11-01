const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db');
const bcrypt = require('bcrypt');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

// Create a challenge
app.post('/api/challenges', (req, res) => {
    const { name } = req.body;
    db.query('INSERT INTO challenges (name) VALUES (?)', [name], (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(201).json({ id: results.insertId, name });
    });
});

// Get all challenges
app.get('/api/challenges', (req, res) => {
    db.query('SELECT * FROM challenges', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Register a new user
app.post('/api/register', async (req, res) => {
    const { username, email, password, age, fitnessLevel } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    db.query('INSERT INTO users (username, email, password, age, fitnessLevel) VALUES (?, ?, ?, ?, ?)', 
             [username, email, hashedPassword, age, fitnessLevel], (err) => {
        if (err) return res.status(500).send(err);
        res.status(201).send('User registered');
    });
});

// Get leaderboard (dummy data for now)
app.get('/api/leaderboard', (req, res) => {
    // This should be replaced with actual leaderboard logic
    const leaderboard = [
        { username: 'User1', score: 100 },
        { username: 'User2', score: 90 },
    ];
    res.json(leaderboard);
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
