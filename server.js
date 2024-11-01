const express = require('express');
const { Pool } = require('pg');
const session = require('express-session');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const app = express();
const PORT = 4000;

// PostgreSQL connection pool
const pool = new Pool({
    host: 'localhost',
    user: 'postgres',
    password: '0912', // Change this to your PostgreSQL password
    database: 'newdata',
    port: 5432,
});

// Set EJS as the templating engine
app.set('view engine', 'ejs');

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
    secret: 'your_secret_key', // Change this to a strong secret
    resave: false,
    saveUninitialized: true,
}));
app.use(express.static('public'));

// Login route
app.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
        if (result.rows.length > 0) {
            const user = result.rows[0];
            const match = await bcrypt.compare(password, user.password);
            if (match) {
                req.session.user = { id: user.id, username: user.username };
                console.log('User logged in:', req.session.user);
                return res.redirect('/home');
            }
        }
        res.status(401).send('Invalid username or password');
    } catch (err) {
        console.error('Error querying the database:', err);
        res.status(500).send('Server error');
    }
});

// Registration route
app.post('/register', async (req, res) => {
    const { username, password, email } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    try {
        // Check if username or email already exists
        const userCheck = await pool.query('SELECT * FROM users WHERE username = $1 OR email = $2', [username, email]);
        if (userCheck.rows.length > 0) {
            return res.status(400).send('Username or email already exists');
        }

        await pool.query('INSERT INTO users (username, password, email) VALUES ($1, $2, $3)', [username, hashedPassword, email]);
        res.status(201).redirect('/login.html'); // Redirect to login after registration
    } catch (err) {
        console.error('Error inserting user into database:', err);
        res.status(500).send('Server error');
    }
});

// Home route
app.get('/home', (req, res) => {
    if (req.session.user) {
        res.render('home', { username: req.session.user.username });
    } else {
        res.redirect('/login.html');
    }
});

// Display all challenges
app.get('/challenges', async (req, res) => {
    if (req.session.user) {
        try {
            const result = await pool.query('SELECT * FROM challenges WHERE user_id = $1', [req.session.user.id]);
            const challenges = result.rows;
            res.render('challenges', { username: req.session.user.username, challenges });
        } catch (err) {
            console.error('Error fetching challenges:', err);
            res.status(500).send('Server error');
        }
    } else {
        res.redirect('/login.html');
    }
});

// Route to mark a challenge as completed
app.post('/challenges/:id/complete', async (req, res) => {
    if (req.session.user) {
        const challengeId = req.params.id;
        try {
            await pool.query('UPDATE challenges SET status = $1 WHERE id = $2 AND user_id = $3', ['completed', challengeId, req.session.user.id]);
            res.redirect('/my-challenges');
        } catch (err) {
            console.error('Error updating challenge status:', err);
            res.status(500).send('Server error');
        }
    } else {
        res.redirect('/login.html');
    }
});

// Route to create a new challenge
app.get('/create-challenge', (req, res) => {
    if (req.session.user) {
        res.render('create-challenge', { username: req.session.user.username });
    } else {
        res.redirect('/login.html');
    }
});

app.post('/create-challenge', async (req, res) => {
    if (req.session.user) {
        const { title, description, start_date, end_date } = req.body;
        try {
            await pool.query('INSERT INTO challenges (user_id, title, description, start_date, end_date, status) VALUES ($1, $2, $3, $4, $5, $6)', 
                [req.session.user.id, title, description, start_date, end_date, 'incomplete']);
            res.redirect('/my-challenges');
        } catch (err) {
            console.error('Error creating challenge:', err);
            res.status(500).send('Server error');
        }
    } else {
        res.redirect('/login.html');
    }
});

// View specific user challenges
app.get('/my-challenges', async (req, res) => {
    if (req.session.user) {
        try {
            const result = await pool.query('SELECT * FROM challenges WHERE user_id = $1', [req.session.user.id]);
            const challenges = result.rows;
            res.render('my-challenges', { username: req.session.user.username, challenges });
        } catch (err) {
            console.error('Error fetching user challenges:', err);
            res.status(500).send('Server error');
        }
    } else {
        res.redirect('/login.html');
    }
});

// Logout route
app.get('/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).send('Error logging out');
        }
        res.redirect('/login.html');
    });
});

// Route to update a challenge
app.put('/challenges/:id', async (req, res) => {
    if (req.session.user) {
        const { title, description, status } = req.body;
        const challengeId = req.params.id;
        try {
            await pool.query('UPDATE challenges SET title = $1, description = $2, status = $3 WHERE id = $4 AND user_id = $5', 
                [title, description, status, challengeId, req.session.user.id]);
            res.status(200).send('Challenge updated successfully');
        } catch (err) {
            console.error('Error updating challenge:', err);
            res.status(500).send('Server error');
        }
    } else {
        res.redirect('/login.html');
    }
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
