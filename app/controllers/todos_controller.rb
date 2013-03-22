class TodosController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @todos = current_user.todos.order(:created_at)
    respond_with @todos
  end

  def create
    @todo = current_user.todos.create params[:todo]
    respond_with @todo
  end

  def update
    @todo = current_user.todos.find params[:id]
    @todo.update_attributes params[:todo]
    respond_with @todo
  end

  def destroy
    @todo = current_user.todos.find params[:id]
    @todo.destroy
    respond_with @todo
  end
end
