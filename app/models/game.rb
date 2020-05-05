class Game < ApplicationRecord
	def self.start(player1, player2)
    # Randomly distribute cards and color. Sets up answer as well.
    cross, nought = [player1, player2].shuffle

    # Let players know what happened
    ActionCable.server.broadcast "player_#{cross}", {msg: "Cross", action: "hide"}
    ActionCable.server.broadcast "player_#{nought}", {msg: "Nought", action: "hide"}

    # Send UUID to client
    ActionCable.server.broadcast "player_#{cross}", {msg: player1, action: "set_identity"}
    ActionCable.server.broadcast "player_#{nought}", {msg: player2, action: "set_identity"}

    ActionCable.server.broadcast "player_#{nought}", {msg: "Nought", action: "unhide"}

    # Store the details of each opponent
    # REDIS.set("opponent_for:#{cross}", nought)
    # REDIS.set("opponent_for:#{nought}", cross)
  end

  # def self.opponent_for(uuid)
  #REDIS.get("opponent_for:#{uuid}")
  #end

  #def self.take_turn(uuid, move)
  #  opponent = opponent_for(uuid)

  #  ActionCable.server.broadcast "player_#{opponent}", {action: "take_turn", move: move['data']}
  #end
end
