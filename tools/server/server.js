// Requiring module
const express = require('express');
const cors    = require('cors');
const process = require('process');  
// Creating express app object
const app = express();
  
// CORS is enabled for all origins
app.use(cors());
  
// Example api 
//app.get('/flisting', 
//    (req, res) => res.json('test 1 2 3.... '));

app.get('/xterm', (req, res) => {

const { spawn } = require("child_process");
//process.chdir('/home/york/pages');
//const ls = spawn("ls", ["-la"]);
const ls = spawn("xterm");

});

app.get('/', (req, res) => {

  res.send('Hello')

//const { spawn } = require("child_process");
//process.chdir('/home/york/pages');
//const ls = spawn("ls", ["-la"]);
//const ls = spawn("xterm");

});
// gsearch
// {{{
app.get('/gsearch', (req, res) => {
  const kw      = req.query.keywords;
  const dbpath  = req.query.dbpath;

  const sqlite3 = require("sqlite3").verbose();
  var db =  new sqlite3.Database(dbpath);

  console.log(kw);

  let sql = "SELECT * FROM global WHERE keywords like '%" + kw + "%'";
  //console.log(sql);

  db.all(sql, (error, row) => {
    res.json(row)
  });
});
// }}}
// bundle
// {{{
app.get('/bundle', (req, res) => {
  const size       = req.query.size;
  const filepath   = req.query.filepath;
  const sqldb      = req.query.sqldb;

  console.log(size)

  const fs = require("fs");
  const sqlite3 = require("sqlite3").verbose();
  const db = new sqlite3.Database(filepath, (error) => {
    console.log(filepath);
  });

  let sql = 'SELECT * FROM '+sqldb+' ORDER BY RANDOM() LIMIT '+size
  //let sql = "SELECT * FROM codeall ORDER BY RANDOM() LIMIT "+size+"\"";

  db.all(sql, (error, row) => {
    res.json(row)
  });
});
// }}}
// goglobal
// {{{
app.get('/goglobal', (req, res) => {
  const cwd = req.query.cwd;

  console.log(cwd)

  const { spawn } = require('child_process');

  const child = spawn('./goglobal.tcl', [cwd], {
      detached: true,
  });
  
  child.stdout.on('data', (data) => {
    console.log(`stdout:\n${data}`);
  });
  
  child.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
  });
  
  child.on('error', (error) => {
    console.error(`error: ${error.message}`);
  });
});
// }}}
// cmdline
// {{{
app.get('/cmdline', (req, res) => {
  const fullpath = req.query.fullpath;
  const cmd      = req.query.cmd;
  const param    = req.query.param;

  const parameters = param ? param.split(' ') : [];

  console.log(parameters)
  console.log(fullpath)

  process.chdir(fullpath);

  const { spawn } = require("child_process");

  const child = spawn(cmd, parameters);

  child.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
  });

  child.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
  });

  child.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
  });

  return res.json({ status: 'success' });

});
// }}}
// lsearch
// {{{
app.get('/lsearch', (req, res) => {
  const kw      = req.query.keywords;
  const dbpath  = req.query.dbpath;

  const sqlite3 = require("sqlite3").verbose();
  var db =  new sqlite3.Database(dbpath);

  console.log(kw);

  let sql = "SELECT * FROM dbtable WHERE keywords like '%" + kw + "%'";
  //console.log(sql);

  db.all(sql, (error, row) => {
    res.json(row)
  });
});
// }}}
  
app.use('/', require('./routes/func.js'));

// Port Number
//const port = 5000;
const port = process.env.GODEL_SERVER_PORT;

// Server setup
app.listen(port, () => `Server running on port ${port}`);


// vim:fdm=marker
