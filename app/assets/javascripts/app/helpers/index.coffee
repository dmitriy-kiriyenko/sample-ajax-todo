#= require ../index

app = @app
app.helpers =
  pluralize: (count, word)-> if count == 1 then word else "#{word}s"
