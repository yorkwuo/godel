const express = require('express');
const router = express.Router();
const fs = require('fs');
const os = require('os')
const godel_root = process.env.GODEL_ROOT

//--------------------
// face (adhoc_draw.tcl)
//--------------------
// {{{
router.get('/face', (req, res) => {
  console.log(godel_root)

  const path = req.query.path;
  const ghtm = req.query.ghtm;

  const homedir = os.homedir()

  console.log(homedir)

// change directory
  process.chdir(path);

  const { exec } = require("child_process");

  const scriptPath = 'adhoc_draw.tcl';
  const outputPath = `${homedir}/o.html`;

  // Parameters to pass to the script
  const param1 = '-f';
  let param2 = ghtm;

  if (param2 == 'ls_table.tcl') { 
    param2 = `${godel_root}/ghtm/ls_table.tcl`
  }

  // Execute the script with parameters
  exec(`${scriptPath} ${param1} ${param2} -o ${outputPath}`, (error, stdout, stderr) => {
      if (error) {
          console.error(`Error executing script: ${error.message}`);
          return res.status(500).send(`Error executing script: ${error.message}`);
      }
      if (stderr) {
          console.error(`Script error output: ${stderr}`);
          return res.status(500).send(`Script error output: ${stderr}`);
      }

      // Read the content of the output file
      fs.readFile(outputPath, 'utf8', (err, data) => {
          if (err) {
              console.error(`Error reading output file: ${err.message}`);
              return res.status(500).send(`Error reading output file: ${err.message}`);
          }

          // Send the content of the output file back to the client
          res.send(data);
      });
  });
});
// }}}
//--------------------
// genface (execute script directly to generate o.html)
//--------------------
// {{{
router.get('/genface', (req, res) => {

  const path = req.query.path;
  const ghtm = req.query.ghtm;

  const homedir = os.homedir()


// change directory
  const { exec } = require("child_process");
  process.chdir(path);

  //const scriptPath = 'adhoc_draw.tcl';
  const outputPath = `${homedir}/o.html`;


  // Execute the script with parameters
  exec(`${ghtm}`,{ maxBuffer: 1024 * 1024 * 10 }, (error, stdout, stderr) => {
      if (error) {
          console.error(`Error executing script: ${error.message}`);
          //return res.status(500).send(`Error executing script: ${error.message}`);
      }
      if (stderr) {
          console.error(`Script error output: ${stderr}`);
          //return res.status(500).send(`Script error output: ${stderr}`);
      }

      // Read the content of the output file
      fs.readFile(outputPath, 'utf8', (err, data) => {
          if (err) {
              console.error(`Error reading output file: ${err.message}`);
              return res.status(500).send(`Error reading output file: ${err.message}`);
          }

          // Send the content of the output file back to the client
          res.send(data);
      });
  });
});
// }}}
//--------------------
// execmd (exec command in local directory)
//--------------------
// {{{
router.get('/execmd', (req, res) => {

  const path = req.query.path;
  const cmd  = req.query.cmd;

  
  console.log(path)
  console.log(cmd)

// change directory
  process.chdir(path);

  //const { exec } = require("child_process");

  //// Execute the script with parameters
  //exec(`${cmd}`, (error, stdout, stderr) => {
  //    if (error) {
  //        console.error(`Error executing script: ${error.message}`);
  //        //return res.status(500).send(`Error executing script: ${error.message}`);
  //    }
  //    if (stderr) {
  //        console.error(`Script error output: ${stderr}`);
  //        //return res.status(500).send(`Script error output: ${stderr}`);
  //    }

  //    return res.json({ status: 'success' });
  //});
  const { spawn } = require('child_process');
  const script = spawn(cmd, {
    shell: true,
    detached: true,
    stdio: 'ignore'
  })

  script.unref()

});
// }}}
//--------------------
// base64img
//--------------------
// {{{
router.post('/base64img', (req, res) => {
    const base64Data = req.body.image;
    const dir        = req.body.dir;
    console.log(dir)

    // change directory
    process.chdir(dir);

    // Specify the image file path (e.g., save to /uploads/image.png)
    //const filePath = path.join(__dirname, 'uploads', 'image.png');
    const filePath = 'image.png'

    // Convert base64 to binary data
    const imageBuffer = Buffer.from(base64Data, 'base64');

    // Write the binary data to a file
    fs.writeFile(filePath, imageBuffer, (err) => {
        if (err) {
            return res.status(500).json({ message: 'Failed to save image', error: err });
        }
        res.json({ message: 'Image uploaded successfully', path: filePath });
    });
});
// }}}
//-------------------------------------------------
// sqlupdate
//-------------------------------------------------
// {{{
router.get('/sqlupdate', (req, res) => {
  const dbpath  = req.query.dbpath;
  const dbtable = req.query.dbtable;
  const key     = req.query.key;
  const value   = req.query.value;
  const idname  = req.query.idname;
  const idvalue = req.query.idvalue;

  const sqlite3 = require("sqlite3").verbose();
  console.log(dbpath)
  var db =  new sqlite3.Database(dbpath);

  if (idname === undefined) {
    console.log('sqlupdate: set ltable')
    db.run(`INSERT OR IGNORE INTO ${dbtable} (key) VALUES ('${key}')`);
    db.run(`UPDATE ${dbtable} SET value='${value}' WHERE key='${key}'`);
    console.log(`INSERT OR IGNORE INTO ${dbtable} (key) VALUES ('${key}')`)
    console.log(`UPDATE ${dbtable} SET value='${value}' WHERE key='${key}'`)
  } else {
    console.log('sqlupdate: update where')
    var sql = `UPDATE ${dbtable} SET '${key}'='${value}' WHERE ${idname}='${idvalue}'`
    console.log(sql)
    db.all(sql, (err) => {
      if (err) {
        return res.status(500).json({ status: 'error', message: err.message });
      }
    });
  }


  return res.json({status: 'success'})
});
// }}}

module.exports = router;

// vim:fdm=marker
