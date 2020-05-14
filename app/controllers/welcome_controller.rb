class WelcomeController < ApplicationController
  def index
  end

  def message
	message = params[:p]
	player_name = cookies[:name]
	order = Rails.cache.read("turn_order")
	for i in 0..order.length-1
		uuid = order[i]
		ActionCable.server.broadcast "player_#{uuid}", { action: "send_message", message: message, player_name: player_name}
	end
  end

  def entry
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
  end

  def dice_roll
	roll = rand(2..12) 
	current = cookies[:uuid]
	ActionCable.server.broadcast "player_#{current}", { action: "move", msg: roll}
	# need to modify this to let everyone know what you rolled 
  end 

  def rumor
  	Rails.cache.write("current_rumor", [params[:room], params[:weapon], params[:person]])
  	order = Rails.cache.read("turn_order")
  	options = []
  	next_player_cards = Rails.cache.read(order[1])
  	rumor_cards = Rails.cache.read("current_rumor")
  	for i in 0..2
  		if next_player_cards.include? rumor_cards[i] 
  			options.append(rumor_cards[i])
  		end
  	end
  	ActionCable.server.broadcast "player_#{order[1]}", { action: "check_rumor", rumor: options}

  end

  def choose
  	order = Rails.cache.read("turn_order")
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "private_message", message: params[:card] }
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "end_turn"}
  end

  def set_name_cookie
	name = params[:p]
	cookies[:name] = name
	# gotta hide cookie
  end 

  def end_turn
  	order = Rails.cache.read("turn_order")
  	last_player = order.shift
  	order << last_player
  	Rails.cache.write("turn_order", order)
  	ActionCable.server.broadcast "player_#{order[0]}", {msg: "your turn is starting", action: "start_turn"}
  end

# check choice. If the choice is the choice is they have the card, then broadcast this to original guy. 
# Else, check_rumor the other guy?
# if there's no other guy, then broadcast that nothing was done.


end

# def determine_location
#  determine location. [If intrigue, If Rumor, call rumor function. give them an intrigue,] -> then call end of turn. If pool, call the pool function. 
#   At the end, send end of turn. 
# Broadcast rumor, take them to JS