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

# def dice_roll
# 	roll a number. 
# 	broadcast that they can move this number. MakeMove(#)
#  	This will now go back to game channel.js
# end 

# def determine_location
#  determine location. [If intrigue, If Rumor, call rumor function. give them an intrigue,] -> then call end of turn. If pool, call the pool function. 
#   At the end, send end of turn. 
# Broadcast rumor, take them to JS

# def check_rumor (input from player)
# checks order, then broadcast to the first player in order. to player what we see, and which one they'd like to show.
# end. 

# check choice. If the choice is the choice is they have the card, then broadcast this to original guy. 
# Else, check_rumor the other guy?
# if there's no other guy, then broadcast that nothing was done.

# def pass_to next person.
# broadcast_take turn. this goes back to gamechannel now. 
end
