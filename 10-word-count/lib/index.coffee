through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1

  findCapitalIndexs = (word) ->
    upperLetter = 0
    i = 1
    while i < word.split('').length - 1
      letter = word.split('')[i]
      if letter == letter.toUpperCase()
        upperLetter++
        i++
      i++
    upperLetter

  transform = (chunk, encoding, cb) ->
    layers = chunk.split('\n')
    lines = layers.length
    for layer in layers
      quoteNum = layer.split('').filter (x) -> x =='"'.length
      layerArr = layer.trim().replaceAll(/".*"/g, '').split(' ')
      for word in layerArr
        if findCapitalIndexs(word) 
          words = words + findCapitalIndexs(word)
      words = words + quoteNum/2 + layerArr.length
    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
