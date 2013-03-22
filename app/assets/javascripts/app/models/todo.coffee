#= require ./index

class Todo
  constructor: (attributes) ->
    {@id, @title, @completed, @priority} = 
      _(attributes).defaults completed: false, priority: 0

  update: ( {title, completed, priority} ) ->
    @title = title if title?
    @completed = completed if completed?
    @priority = priority if priority?
    @

  toggle: ->
    @update completed: !@completed

  switchPriority: ->
    @update priority: (@priority + 1) % 3

  attributes: ->
    title: title,
    completed: completed,
    priority: priority

  priorityCodes: -> ['low', 'normal', 'high']
  priorityString: -> @priorityCodes()[@priority]


app.models.Todo = Todo
