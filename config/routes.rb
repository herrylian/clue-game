Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  post 'message' => 'welcome#message', as: :message
  post 'entry' => 'welcome#entry', as: :entry
  post 'dice_roll' => 'welcome#dice_roll', as: :dice_roll
  post 'set_name_cookie' => 'welcome#set_name_cookie', as: :set_name_cookie
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
