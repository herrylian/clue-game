Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  post 'message' => 'welcome#message', as: :message
  post 'entry' => 'welcome#entry', as: :entry
  post 'priv' => 'welcome#priv', as: :priv
  post 'dice_roll' => 'welcome#dice_roll', as: :dice_roll
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
