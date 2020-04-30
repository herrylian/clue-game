Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  post 'msg' => 'welcome#msg', as: :msg
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
