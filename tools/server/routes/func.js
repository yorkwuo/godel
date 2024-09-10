const express = require('express');
const router = express.Router();
const fs = require('fs');
const os = require('os')
const godel_root = process.env.GODEL_ROOT

//--------------------
// face (adhoc_draw.tcl)
//--------------------
router.get('/face', (req, res) => {
  console.log(godel_root)

  const path = req.query.path;
  const ghtm = req.query.ghtm;

  const homedir = os.homedir()

  console.log(homedir)

// change directory
  const { exec } = require("child_process");
  process.chdir(path);

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

//--------------------
// genface (execute script directly to generate o.html)
//--------------------
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
  exec(`${ghtm}`, (error, stdout, stderr) => {
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


module.exports = router;

