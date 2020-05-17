class Game < ApplicationRecord
	def self.start()
	    
	    # Randomize order of players and store order in cache.
	    turn_order = [Rails.cache.read('player1'), Rails.cache.read('player2'), Rails.cache.read('player3')].shuffle
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

	    # Distributes the rest of the cards randomly and announce order of the game. 
	    distributed_cards = cards.each_slice(7).to_a
	    first = Rails.cache.read(turn_order[0]+"_name")
	    second = Rails.cache.read(turn_order[1]+"_name")
	    third = Rails.cache.read(turn_order[2]+"_name")
	    kickoff_message = "<br>Everyone is ready! Let's start the game. <br>"+first+" is first. They will roll the dice now. Next will be "+second+". "+third+" is last."

	    for i in 0..2
	    	Rails.cache.write(turn_order[i], distributed_cards[i])
	    	for f in 0..6
	    		ActionCable.server.broadcast "player_#{turn_order[i]}", { action: "add_cards", cards: distributed_cards[i][f] }
	    	end
	    	ActionCable.server.broadcast "player_#{turn_order[i]}", { action: "send_message", message: kickoff_message, player_name: "Game announcer" }
	    end 

	    ActionCable.server.broadcast "player_#{turn_order[0]}", { action: "start_turn" }

	end
end
