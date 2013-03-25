#= require ./index
#= require ../storage/todos

todos = app.storage.todos
pluralize = app.helpers.pluralize
todoTemplate = app.templates['todos/item']
footerTemplate = app.templates['footer/show']
enterKey = 13

class TodoList

  constructor: (root)->
    @cacheElements(root)
    @bindEvents()
    @render() if todos.fetched

  cacheElements: (root)->
    @root            = $(root)
    @newItem         = @root.find('#new-todo')
    @toggleAllButton = @root.find('#toggle-all')
    @main            = @root.find('#main')
    @itemList        = @root.find('#todo-list')
    @footer          = @root.find('#footer')
    @count           = @root.find('#todo-count')
    @clearAllButton  = @root.find('#clear-completed')

  bindEvents: ->
    $(todos).on         'change'  ,                         => @render()

    @newItem.on         'keyup'   ,                      (e)=> @create(e)
    @toggleAllButton.on 'change'  ,                      (e)=> @toggleAll(e)
    @itemList.on        'change'  , '.toggle'          , (e)=> @toggle(e)
    @itemList.on        'dblclick', 'label'            , (e)=> @edit(e)
    @itemList.on        'keypress', '.edit'            , (e)=> @blurOnEnter(e)
    @itemList.on        'blur'    , '.edit'            , (e)=> @blur(e)
    @itemList.on        'click'   , '.priority'        , (e)=> @switchPriority(e)
    @itemList.on        'click'   , '.destroy'         , (e)=> @destroy(e)
    @footer.on          'click'   , '#clear-completed' , (e)=> @clearCompleted(e)

  render: ->
    @itemList.html todoTemplate(todos.items)
    @main.toggle todos.any()
    @toggleAllButton.prop 'checked', !todos.anyActive()
    @renderFooter()

  renderFooter: ->
    @footer.toggle todos.any()
    @footer.html footerTemplate @footerData()

  footerData: ->
    activeCount: todos.activeItemsCount()
    activeWord: app.helpers.pluralize todos.activeItemsCount(), 'item'
    completedCount: todos.completedItemsCount()

  toggleAll: (event)->
    todos.forceStatus $(event.target).prop 'checked'

  clearCompleted: (event)->
    todos.destroyCompleted()

  toggle: (event) ->
    todos.toggle @getId(event.target)

  create: (event) ->
    input = $(event.target)
    value = $.trim input.val()

    if event.which != enterKey or not value then return

    todos.create title: value

    input.val ''

  getId: (element) ->
    $(element).closest('li').data('id')

  edit: (event) ->
    $(event.target).closest('li').addClass('editing').find('.edit').focus()

  blurOnEnter: (event) ->
    if event.which == enterKey then $(event.target).trigger 'blur'

  blur: (event) ->
    input = $(event.target)
    value = $.trim input.removeClass('editing').val()
    todos.updateOrDelete(@getId(input), title: value)

  switchPriority: (event) ->
    todos.switchPriority @getId event.target

  destroy: (event) ->
    todos.destroy @getId event.target

app.widgets.TodoList = TodoList
