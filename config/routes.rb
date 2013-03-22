TodoInterview::Application.routes.draw do
  devise_for :users

  root to: 'todo_list#show'
  resources :todos, only: [:index, :create, :edit, :update, :destroy]
end
