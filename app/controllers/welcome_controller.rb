class WelcomeController < ApplicationController
  def index
  end

  def message
	message = params[:p]
	order = Rails.cache.read("turn_order")
	for i in 0..order.length-1
		uuid = order[i]
		ActionCable.server.broadcast "player_#{uuid}", { msg: message}
	end
  end

  def entry
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
  end

  def dice_roll
	roll = rand(2..12) 
	order = Rails.cache.read("turn_order")
	current = order[0]
	ActionCable.server.broadcast "player_#{current}", { action: "move", msg: roll}
  end 
  
  def check_rumor(room, weapon, person)
	order = Rails.cache.read("turn_order")
	# broadcast that it's going to order[1]
	# check if they have it. 
	# then broadcast to the first player in order. to player what we see, and which one they'd like to show.

  end	


# check choice. If the choice is the choice is they have the card, then broadcast this to original guy. 
# Else, check_rumor the other guy?
# if there's no other guy, then broadcast that nothing was done.

# def pass_to next person.
# broadcast_take turn. this goes back to gamechannel now. 
end

# def determine_location
#  determine location. [If intrigue, If Rumor, call rumor function. give them an intrigue,] -> then call end of turn. If pool, call the pool function. 
#   At the end, send end of turn. 
# Broadcast rumor, take them to JS