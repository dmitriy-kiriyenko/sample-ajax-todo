#= require ./index

class Todo
  constructor: ( {@id, @title, @completed, @priority} ) ->

  update: ( {title, completed, priority} ) ->
    @title = title if title?
    @completed = completed if completed?
    @priority = priority if priority?
    @

  priorityCodes: -> ['low', 'normal', 'high']
  priorityString: -> @priorityCodes()[@priority]


app.models.Todo = Todo
