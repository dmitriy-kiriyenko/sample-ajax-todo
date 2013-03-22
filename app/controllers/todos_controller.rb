class TodosController < ApplicationController
  respond_to :json

  def index
    @todos = Todo.all
    respond_with(@todos)
  end

  def create
    @todo = Todo.create params[:todo]
    respond_with(@todo)
  end
end
