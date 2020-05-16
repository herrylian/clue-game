Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  post 'message' => 'welcome#message', as: :message
  post 'entry' => 'welcome#entry', as: :entry
  post 'dice_roll' => 'welcome#dice_roll', as: :dice_roll
  post 'set_name_cookie' => 'welcome#set_name_cookie', as: :set_name_cookie
  post 'rumor' => 'welcome#rumor', as: :rumor
  post 'choose' => 'welcome#choose', as: :choose
  post 'end_turn' => 'welcome#end_turn', as: :end_turn
  post 'pass' => 'welcome#pass', as: :pass
  post 'skip' => 'welcome#skip', as: :skip

end
