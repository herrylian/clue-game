class Match < ApplicationRecord
	def self.create(uuid)
    	case Rails.cache.read("people")
    	when nil
    		Rails.cache.write("people", 1)
    		Rails.cache.write('player1', uuid)
            ActionCable.server.broadcast "player_#{uuid}", {action: "set_identity", uuid: uuid}

    	when 1
    		Rails.cache.write("people", 2)
            Rails.cache.write('player2', uuid)
    		ActionCable.server.broadcast "player_#{uuid}", {action: "set_identity", uuid: uuid}
    	when 2
	  		Rails.cache.write('player3', uuid)
            ActionCable.server.broadcast "player_#{uuid}", {action: "set_identity", uuid: uuid}
      		Rails.cache.write("people", nil)
            Rails.cache.write("start", "yes")
	    end  	
    end
end
