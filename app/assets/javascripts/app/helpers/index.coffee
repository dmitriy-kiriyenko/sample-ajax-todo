#= require ../index

app = @app
app.helpers =
  pluralize: (count, word)-> if count == 1 then word else "#{word}s"
  uuid: ->
    uuid = ''

    for i in [0...32] by 1
      random = Math.random() * 16 | 0
      if i == 8 || i == 12 || i == 16 || i == 20
        uuid += '-'
        uuid += ( if i == 12 then 4 else ( if i == 16 then (random & 3 | 8) else random)).toString(16)

    uuid
