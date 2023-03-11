const mysql = require('mysql2');

const conn = mysql.createConnection({
    host: "localhost", 
    user: "root", 
    password: "yesmysql123",
    database: "coden"     
});
  
conn.connect(function(err) {  
    if (err) throw err;
    console.log("Connected!");
});

module.exports = conn;