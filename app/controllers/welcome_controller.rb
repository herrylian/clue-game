class WelcomeController < ApplicationController
  def index
  end

  def msg
	message = params[:p]
	ActionCable.server.broadcast "global_channel", { body: message}
  end
  
  def entry
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
  end

end
