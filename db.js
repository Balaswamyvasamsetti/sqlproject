const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'bala', // replace with your MySQL username
    password: '0912', // replace with your MySQL password
    database: 'fitness_challenge' // replace with your database name
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the database');
});

module.exports = db;
