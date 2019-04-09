###
Test for hashes match with OpenSSL
###
assert = require 'assert'
spawn = require 'child_process'
  .spawn

forge = require 'node-forge'
pki = forge.pki

ca = require '..'
der2 = ca.der2
hash = require '../lib/hash'
hach = require '../lib/hash_old'

run = (args, cb)->
  if "string" == typeof args
    args = args.split /\s+/
  out = ''
  child = spawn 'openssl', args
  child.on 'error', (error)->
    out = null
    cb error
  child.stdout
  .on 'data', (data)->
    out += data if out?
  .on 'end', ->
    cb null, out.trim()  if out?
  child.stdin

run 'version', (error, ver)->
  if error
    console.error 'OpenSSL not found. Skipping hashes test...'
    return
  console.log 'Found:', ver
  list = ca.all der2.der

  N = 0

  do match = ->
    unless crt = list.pop()
      console.log 'Hashes ok: 2 *', N
      return

    run 'x509 -noout -subject_hash -subject_hash_old', (error, out)->
      throw error if error
      out = out.split /\s+/
      assert.equal 2, out.length
      assert.equal out[0], hash crt
      assert.equal out[1], hach crt
      N++

      do match
    .end der2 der2.pem, crt
