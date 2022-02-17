assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count a single Camel word', (done) ->
    input = 'sIngle'
    expected = words: 2, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count multiple lines', (done) ->
    input = 'this is first line \n this is second line'
    expected = words: 8, lines: 2
    helper input, expected, done

  it 'should count complex situation', (done) ->
    input = 'this is first line \n this is second line \n "this is third line"'
    expected = words: 9, lines: 3
    helper input, expected, done

  it 'should count complex situation with doube quote', (done) ->
    input = 'this is first line \n this is second line \n "this is third line" this is third line'
    expected = words: 13, lines: 3
    helper input, expected, done
 
  it 'should count complex situation with doube quotea and camel word', (done) ->
    input = 'this is fIrst line \n this is sEcond line \n "this is third line" this is tTird line'
    expected = words: 16, lines: 3
    helper input, expected, done