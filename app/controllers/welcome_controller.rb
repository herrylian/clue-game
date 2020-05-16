class WelcomeController < ApplicationController
  def index
  end
  
  def set_name_cookie
  	player_name = params[:p]
  	cookies[:name] = player_name
    uuid = cookies[:uuid]
    Rails.cache.write(uuid, player_name)
  	# gotta hide cookie
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

  def dice_roll
  	roll = rand(2..12) 
  	player_uuid = cookies[:uuid]
    # player_name = cookies[:name]
    roll_string = roll.to_s
    message = "Someone" + " rolled a " + roll_string + "."
    order = Rails.cache.read("turn_order")
    for i in 1..2
      uuid = order[i]
      ActionCable.server.broadcast "player_#{uuid}", { action: "send_message", message: message, player_name: "game announcer"}
    end
  	ActionCable.server.broadcast "player_#{player_uuid}", { action: "move", msg: roll}
  	# need to modify this to let everyone know what you rolled 
    # Announce to other players what the dice roll was
    
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
  	ActionCable.server.broadcast "player_#{order[1]}", { action: "check_rumor", rumor: options, last: "false" }
  end

  def skip
    rumor_cards = Rails.cache.read("current_rumor")
    order = Rails.cache.read("turn_order")
    options = []
    next_player_cards = Rails.cache.read(order[2])
    for i in 0..2
      if next_player_cards.include? rumor_cards[i] 
        options.append(rumor_cards[i])
      end
    end
    ActionCable.server.broadcast "player_#{order[2]}", { action: "check_rumor", rumor: options, last: "true" }
  end

  def pass
  	order = Rails.cache.read("turn_order")
  	player_name = cookies[:name]
  	player_uuid = cookies[:uuid]
  	message = player_name" did not show a card and passed."
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "send_message", message: message }
  	ActionCable.server.broadcast "player_#{order[1]}", { action: "send_message", message: message }
  	ActionCable.server.broadcast "player_#{order[2]}", { action: "send_message", message: message }

  	ActionCable.server.broadcast "player_#{player_uuid}", { action: "hide_pass_button" }
    ActionCable.server.broadcast "player_#{order[0]}", { action: "end_turn"}
  end
  	
  def choose
  	order = Rails.cache.read("turn_order")
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "private_message", message: params[:card] }
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "end_turn"}
  end

  def end_turn
  	order = Rails.cache.read("turn_order")
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "hide_end_turn_button"}
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

#  def entry
#	message = params[:q]
#	Dice.create(:dice => message)
#	sum = [Dice.all.count].to_s
#  end