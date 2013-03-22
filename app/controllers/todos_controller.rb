class TodosController < ApplicationController
  respond_to :json

  def index
    @todos = Todo.order(:created_at)
    respond_with @todos
  end

  def create
    @todo = Todo.create params[:todo]
    respond_with @todo
  end

  def update
    @todo = Todo.find params[:id]
    @todo.update_attributes params[:todo]
    respond_with @todo
  end

  def destroy
    @todo = Todo.find params[:id]
    @todo.destroy
    respond_with @todo
  end
end
