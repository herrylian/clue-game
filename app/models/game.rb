class Game < ApplicationRecord
	def self.start(player1_uuid, player2_uuid)
	    # Send UUID to client
	    ActionCable.server.broadcast "player_#{player1_uuid}", {msg: player1_uuid, action: "set_identity"}
	    ActionCable.server.broadcast "player_#{player2_uuid}", {msg: player2_uuid, action: "set_identity"}

	    # Randomly distribute cards and color. Sets up answer as well.
	    p1, p2 = [player1_uuid, player2_uuid].shuffle

	    cards = ["mustard", "plum", "green", "peacock", "scarlet", "white", "knife", "candlestick", "pistol", "poison", "trophy", "rope", "bat", "ax", "dumbbell", "hall", "dining room", "kitchen", "patio", "observatory", "theater", "living room", "spa", "guest house"]
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
	    puts "cards are:"
	    puts cards

	    # Let players know what happened
	    ActionCable.server.broadcast "player_#{p1}", {msg: "You are first", action: "hide"}
	    ActionCable.server.broadcast "player_#{p2}", {msg: "You are second", action: "hide"}
	    ActionCable.server.broadcast "player_#{p2}", {msg: "unhiding some stuff", action: "unhide"}

	    # Store the order of the game 
	    Rails.cache.write("turn_order", [p1,p2])
	    order = Rails.cache.read("turn_order")

	    # testing for order
	    puts "the order is:"
	    puts order
	    
	    # Start game?
	    ActionCable.server.broadcast "player_#{p1}", {msg: "your turn is starting", action: "start_turn"}
	end

  
  # def start turn(person)

  # def self.opponent_for(uuid)
  #REDIS.get("opponent_for:#{uuid}")
  #end

  #def self.take_turn(uuid, move)
  #  opponent = opponent_for(uuid)

  #  ActionCable.server.broadcast "player_#{opponent}", {action: "take_turn", move: move['data']}
  #end
end
