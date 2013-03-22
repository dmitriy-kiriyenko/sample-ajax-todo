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

  _remoteCreate: (options) ->
    _($.ajax type: 'POST', url: '/todos.json', data: {todo: options}).tap (request)=>
      request.done (data)=>
        @items.push new Todo data
        $(@).trigger 'change'

  _remoteUpdate: (item, options) ->
    _($.ajax type: 'PUT', url: "/todos/#{item.id}.json", data: {todo: options}).tap (request)=>
      request.done (data)=>
        item.update options
        $(@).trigger 'change'

  _remoteDelete: (item) ->
    _($.ajax type: 'DELETE', url: "/todos/#{item.id}.json").tap (request)=>
      request.done (data)=>
        @items = _(@items).reject (i)-> i.id == item.id
        $(@).trigger 'change'

  create: (options) ->
    @_remoteCreate options

  updateOrDelete: (id, options) ->
    if options.title then @update id, options else @destroy id, options

  update: (id, options) ->
    _(@findItem id).tap (item)=>
      @_remoteUpdate item, options

  toggle: (id) ->
    _(@findItem id).tap (item)=>
      @_remoteUpdate item, item.toggledAttrs()

  switchPriority: (id) ->
    _(@findItem id).tap (item)=>
      @_remoteUpdate item, item.switchedPriorityAttrs()

  findItem: (id) ->
    _(@items).find (item) -> item.id == id

  destroy: (id) ->
    @deleteAll (item)-> item.id == id

  destroyCompleted: ->
    @deleteAll (item)-> item.completed

  deleteAll: (condition)->
    @_remoteDelete(item) for item in @items when condition item
    @

  forceStatus: (completed)->
    _(@items).each (item) =>
      @_remoteUpdate item, item.withStatusAttrs(completed)

  itemsCount: -> @items.length
  activeItems: -> _(@items).filter (item)-> !item.completed
  activeItemsCount: -> @activeItems().length
  completedItems: -> _(@items).filter (item)-> item.completed
  completedItemsCount: -> @completedItems().length

  any: -> !!@itemsCount()
  anyActive: -> !!@activeItemsCount()

app.storage.todos = new Todos
