class Game < ApplicationRecord
	def self.start(player1_uuid, player2_uuid, player3_uuid)
	    # Send UUID to client
	    ActionCable.server.broadcast "player_#{player1_uuid}", {msg: player1_uuid, action: "set_identity"}
	    ActionCable.server.broadcast "player_#{player2_uuid}", {msg: player2_uuid, action: "set_identity"}
 		ActionCable.server.broadcast "player_#{player3_uuid}", {msg: player3_uuid, action: "set_identity"}
	    
	    # Randomize order of players
	    turn_order = [player1_uuid, player2_uuid, player3_uuid].shuffle
	    Rails.cache.write("turn_order", turn_order)

		# Randomly distribute cards and color. Sets up answer as well.
	    cards = ["Mustard", "Plum", "Green", "Peacock", "Scarlet", "White", "Knife", "Candlestick", "Pistol", "Poison", "Trophy", "Rope", "Bat", "Ax", "Dumbbell", "Hall", "Dining Room", "Kitchen", "Patio", "Observatory", "Theater", "Living Room", "Spa", "Guest House"]
		person = rand(0..5)
		weapon = rand(6..14)
		room = rand(15..23)
		Rails.cache.write("answer", [cards[person], cards[weapon], cards[room]])
	    cards.delete_at(person)
	    cards.delete_at(weapon-1)
	    cards.delete_at(room-2)
	   	cards.shuffle!
	    answer = Rails.cache.read("answer")

	    puts "answer is:"
	    puts answer

	    distributed_cards = cards.each_slice(7).to_a

	    
	    # first = Rails.cache.read(turn_order[0])
	    # second = Rails.cache.read(turn_order[1])
	    # third = Rails.cache.read(turn_order[2])
	    # kickoff_message = "Let's start the game. "+first+"is first. Next will be "+second+". "+third+" is last."
	    kickoff_message = "Let's start the game. Someone is rolling the dice."
	    # Start game
	    # Let players know the turn order.
	    for i in 0..2
	    	Rails.cache.write(turn_order[i], distributed_cards[i])
	    	for f in 0..6
	    		ActionCable.server.broadcast "player_#{turn_order[i]}", {msg: distributed_cards[i][f], action: "add_cards"}
	    	end
	    	ActionCable.server.broadcast "player_#{turn_order[i]}", {message: kickoff_message, action: "send_message", player: "game announcer"}
	    end 

	    ActionCable.server.broadcast "player_#{turn_order[0]}", {msg: "It's your turn.", action: "start_turn"}


	end
end
