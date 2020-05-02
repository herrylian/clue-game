class WelcomeController < ApplicationController
  def index
  end

  def msg
	message = params[:p]
	Rails.cache.write("a", message)
	puts Rails.cache.read("a")
	ActionCable.server.broadcast "global_channel", { body: message}
  end
  
  def priv
  	name = Rails.cache.read("a")
  	puts name
	ActionCable.server.broadcast "global_channel", { body: name}
  end

  def entry
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
  end

end
