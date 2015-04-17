
fs = require 'fs'
should = require 'should'
parse = if process.env.CSV_COV then require '../lib-cov' else require '../src'

describe 'write', ->

  it 'string randomly splited', (next) ->
    data = []
    parser = parse()
    parser.on 'readable', ->
      while(d = parser.read())
        data.push d
    parser.on 'finish', ->
      data.should.eql [
        [ 'Test 0', '0', '"' ]
        [ 'Test 1', '1', '"' ]
        [ 'Test 2', '2', '"' ]
        [ 'Test 3', '3', '"' ]
        [ 'Test 4', '4', '"' ]
        [ 'Test 5', '5', '"' ]
        [ 'Test 6', '6', '"' ]
        [ 'Test 7', '7', '"' ]
        [ 'Test 8', '8', '"' ]
        [ 'Test 9', '9', '"' ]
      ]
      next()
    buffer = ''
    for i in [0...10]
      buffer += ''.concat "Test #{i}", ',', i, ',', '""""', "\n"
      if buffer.length > 250
        parser.write buffer.substr 0, 250
        buffer = buffer.substr 250
    parser.write buffer
    parser.end()
  
  it 'throw error if not writable', (next) ->
    parser = parse()
    parser.on 'error', (err) ->
      err.message.should.eql 'write after end'
      next()
    parser.write 'abc,123'
    parser.end()
    parser.write 'def,456'
  
