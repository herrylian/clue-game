class WelcomeController < ApplicationController
  def index
  end
  
  def set_name_cookie
  	player_name = params[:p]
  	cookies[:name] = player_name
    uuid = cookies[:uuid]
    uuid_name = uuid+"_name"
    Rails.cache.write(uuid_name, player_name)

    if Rails.cache.read("names_written") == nil
      Rails.cache.write("names_written", 1)
      ActionCable.server.broadcast "player_#{uuid}", { action: "private_message", message: "Welcome, "+player_name+". Waiting on 2 more people." }
      ActionCable.server.broadcast "player_#{uuid}", { action: "hide_name_field" }
    else
      names_written = Rails.cache.read("names_written") + 1
      Rails.cache.write("names_written", names_written)
      ActionCable.server.broadcast "player_#{uuid}", { action: "private_message", message: "Welcome, "+player_name+". Waiting on 1 more person." }
      ActionCable.server.broadcast "player_#{uuid}", { action: "hide_name_field" }
      if Rails.cache.read("start") == "yes" && Rails.cache.read("names_written") == 3
        Rails.cache.write("names_written", nil)
        Rails.cache.write("start", nil)
        Game.start()
      end
    end
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
    player_name = cookies[:name]
    message = player_name + " rolled a " + roll.to_s + "."
    order = Rails.cache.read("turn_order")
    for i in 1..2
      uuid = order[i]
      ActionCable.server.broadcast "player_#{uuid}", { action: "send_message", message: message, player_name: "Game announcer"}
    end
  	ActionCable.server.broadcast "player_#{player_uuid}", { action: "move", msg: roll}    
  end 

  def rumor
  	Rails.cache.write("current_rumor", [params[:room], params[:weapon], params[:person]])
  	order = Rails.cache.read("turn_order")
    player_uuid = cookies[:uuid]
    player_name = cookies[:name]
    options = []
    message = "My rumor is "+params[:room]+", "+params[:weapon]+", "+params[:person]+". <br>"

    for i in 0..order.length-1
      uuid = order[i]
      ActionCable.server.broadcast "player_#{uuid}", { action: "send_message", message: message, player_name: player_name}
    end
  	
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
    player_name = cookies[:name]
    player_uuid = cookies[:uuid]
    options = []
    next_player_cards = Rails.cache.read(order[2])
    for i in 0..2
      if next_player_cards.include? rumor_cards[i] 
        options.append(rumor_cards[i])
      end
    end
    message = "Game Announcer: "+player_name+" did not show a card and skipped."
    ActionCable.server.broadcast "player_#{order[0]}", { action: "send_message", message: message }
    ActionCable.server.broadcast "player_#{order[1]}", { action: "send_message", message: message }
    ActionCable.server.broadcast "player_#{order[2]}", { action: "send_message", message: message }
    ActionCable.server.broadcast "player_#{player_uuid}", { action: "hide_skip_button" }
    ActionCable.server.broadcast "player_#{order[2]}", { action: "check_rumor", rumor: options, last: "true" }
  end

  def pass
  	order = Rails.cache.read("turn_order")
  	player_name = cookies[:name]
  	player_uuid = cookies[:uuid]
  	message = "Game Announcer: "+player_name+" did not show a card and passed."
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "send_message", message: message }
  	ActionCable.server.broadcast "player_#{order[1]}", { action: "send_message", message: message }
  	ActionCable.server.broadcast "player_#{order[2]}", { action: "send_message", message: message }

  	ActionCable.server.broadcast "player_#{player_uuid}", { action: "hide_pass_button" }
    ActionCable.server.broadcast "player_#{order[0]}", { action: "end_turn"}
  end
  	
  def choose
  	order = Rails.cache.read("turn_order")
    player_uuid = cookies[:uuid]
    player_name = cookies[:name]
    private_message = "Game Announcer: "+player_name+" showed "+params[:card]+"."
    message = player_name+" showed a card."
  	ActionCable.server.broadcast "player_#{player_uuid}", { action: "hide_answer_button"}
    ActionCable.server.broadcast "player_#{order[0]}", { action: "private_message", message: private_message }
    ActionCable.server.broadcast "player_#{order[1]}", { action: "send_message", message: message, player_name: "Game Announcer" }
    ActionCable.server.broadcast "player_#{order[2]}", { action: "send_message", message: message, player_name: "Game Announcer" }
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "end_turn"}
  end

  def end_turn
  	order = Rails.cache.read("turn_order")
    player_name = cookies[:name]
  	ActionCable.server.broadcast "player_#{order[0]}", { action: "hide_end_turn_button"}
  	last_player = order.shift
  	order << last_player
  	Rails.cache.write("turn_order", order)
    next_uuid = order[0]+"_name"
    next_player_name = Rails.cache.read(next_uuid)
    message = player_name+" ended their turn. It's now "+next_player_name+"'s turn."
    ActionCable.server.broadcast "player_#{order[0]}", { action: "send_message", message: message, player_name: "Game Announcer"}
    ActionCable.server.broadcast "player_#{order[1]}", { action: "send_message", message: message, player_name: "Game Announcer" }
    ActionCable.server.broadcast "player_#{order[2]}", { action: "send_message", message: message, player_name: "Game Announcer" }

  	ActionCable.server.broadcast "player_#{order[0]}", { action: "start_turn" }
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