Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  post 'msg' => 'welcome#msg', as: :msg
  post 'entry' => 'welcome#entry', as: :entry
  post 'priv' => 'welcome#priv', as: :priv
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
