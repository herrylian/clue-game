class WelcomeController < ApplicationController
  def index
  end

  def msg
	message = params[:p]
	Rails.cache.write("a", "guguguu")

	name = Rails.cache.read("a")

	ActionCable.server.broadcast "global_channel", { body: message, name: name}
  end
  
  def priv
  	message = params[:a]
  end

  def entry
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
  end

end
