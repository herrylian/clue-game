class WelcomeController < ApplicationController
  def index
  end

  def message
	message = params[:p]
	Rails.cache.write("a", message)
	puts Rails.cache.read("a")
	ActionCable.server.broadcast "player_#{uuid}", { msg: message}
  end
  
  def priv
  	name = Rails.cache.read("a")
  	puts name
	ActionCable.server.broadcast "player_#{uuid}", { msg: name}
  end

  def entry
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
  end

end
