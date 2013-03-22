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

  _remoteCreate: (item) ->
    _($.ajax type: 'POST', url: '/todos.json', data: {todo: item.attributes()}).tap (request)=>
      request.done => $(@).trigger 'change'

  _remoteUpdate: (item) ->
    _($.ajax type: 'PUT', url: "/todos/#{item.id}.json", data: {todo: item.attributes()}).tap (request)=>
      request.done => $(@).trigger 'change'

  create: (options) -> 
    _(new Todo(options)).tap (item)=>
      @items.push item
      @_remoteCreate item

  updateOrDelete: (id, options) ->
    if options.title then @update id, options else @destroy id, options

  update: (id, options) ->
    _(@findItem id).tap (item)=>
      item.update options
      @_remoteUpdate item

  toggle: (id) ->
    _(@findItem id).tap (item)=>
      item.toggle()
      @_remoteUpdate item

  switchPriority: (id) ->
    _(@findItem id).tap (item)=>
      item.switchPriority()
      @_remoteUpdate item

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
    _(@items).each (item) =>
      item.update completed: completed
      @_remoteUpdate item

  itemsCount: -> @items.length
  activeItems: -> _(@items).filter (item)-> !item.completed
  activeItemsCount: -> @activeItems().length
  completedItems: -> _(@items).filter (item)-> item.completed
  completedItemsCount: -> @completedItems().length

  any: -> !!@itemsCount()
  anyActive: -> !!@activeItemsCount()

app.storage.todos = new Todos
