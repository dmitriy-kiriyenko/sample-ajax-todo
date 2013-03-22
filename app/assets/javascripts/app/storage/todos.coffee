#= require ./index
#= require ../models/todo

Todo = app.models.Todo

class Todos
  constructor: ->
    @fetch()

  fetch: -> 
    _($.ajax type: 'GET', url: '/todos.json').tap (request)=>
      request.done (data)=>
        @items = _(data).map (attrs)-> new Todo attrs
        @fetched = true
        $(@).trigger 'change'

  create: (options) -> 
    _(new Todo(options)).tap (item)=>
      _($.ajax type: 'POST', url: '/todos.json', data: {todo: options}).tap (request)=>
        request.done (attrs)=>
          @items.push(new Todo attrs)
          $(@).trigger 'change'

  update: (id, options) ->
    _(@findItem id).tap (item)-> item.update options

  updateOrDelete: (id, options) ->
    if options.title then @update id, options else @destroy id, options

  toggle: (id) ->
    _(@findItem id).tap (item)-> item.toggle()

  switchPriority: (id) ->
    _(@findItem id).tap (item)-> item.switchPriority()

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
