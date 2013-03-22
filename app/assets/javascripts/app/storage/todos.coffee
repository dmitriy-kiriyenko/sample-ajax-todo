#= require ./index
#= require ../models/todo

Todo = app.models.Todo

class Todos
  constructor: ->
    @fetch()

  fetch: -> 
    @items = [new Todo(id: 1, title: 'Make a simple todo', priority: 0, completed: true),
              new Todo(id: 2, title: 'Css it',             priority: 1, completed: false),
              new Todo(id: 3, title: 'Earn lots of money', priority: 2, completed: false)]

  create: (options) -> 
    _(new Todo(options)).tap (item)=> @items.push(item)

  update: (id, options) ->
    _(@findItem id).tap (item)-> item.update options

  updateOrDelete: (id, options) ->
    if options.title then @update id, options else @destroy id, options

  toggle: (id) ->
    _(@findItem id).tap (item)-> item.update completed: !item.completed

  switchPriority: (id) ->
    _(@findItem id).tap (item)-> item.update priority: (item.priority + 1) % 3

  findItem: (id) ->
    _(@items).find (item) -> item.id == id

  destroy: (id) ->
    @deleteAll (item)-> item.id == id

  destroyCompleted: ->
    @deleteAll (item)-> item.completed

  deleteAll: (condition)->
    i = @itemsCount()
    (@items.splice i, 1 if condition @items[i]) while i--
    @

  forceStatus: (completed)->
    console.log completed
    _(@items).each (item) -> item.update completed: completed

  itemsCount: -> @items.length
  activeItems: -> _(@items).filter (item)-> !item.completed
  activeItemsCount: -> @activeItems().length
  completedItems: -> _(@items).filter (item)-> item.completed
  completedItemsCount: -> @completedItems().length

  any: -> !!@itemsCount()
  anyActive: -> !!@activeItemsCount()

app.storage.todos = new Todos
