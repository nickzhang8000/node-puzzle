fs = require 'fs'


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    if err then return cb err
    data = data.toString()

    counter = 0

    loop
      index = data.indexOf '\n'
      line = data.substring(0, index)

      if line.length <= 0
        break

      if line.length > 0

        line = line.split '\t'
        # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
        # line[0],       line[1],       line[3]
        if line[3] == countryCode then counter += +line[1] - +line[0]

      data = data.replace(data.substring(0, index+1), "")
    cb null, counter