###
Possible candidates to save PEM files
###
path = require 'path'

module.exports = [
  -> path.join __dirname, '../pem'
  -> path.join process.env.USERPROFILE, '.local/win-ca/pem'
]
