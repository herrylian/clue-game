class WelcomeController < ApplicationController
  def index
  end
  
  def msg
  	message = params[:q]
	Dice.create(:dice => message)
  end
end
