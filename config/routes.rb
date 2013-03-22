TodoInterview::Application.routes.draw do
  root to: 'todo_list#show'
  resources :todos, only: [:index, :create, :edit, :update, :destroy]
end
