class Match < ApplicationRecord
	def self.create(uuid)
    	case Rails.cache.read("people")
    	when nil
    		Rails.cache.write("people", 1)
    		Rails.cache.write('player1', uuid)
    	when 1
    		Rails.cache.write("people", 2)
    		Rails.cache.write('player2', uuid)
    	when 2
	  		player1_uuid = Rails.cache.read('player1')
	  		player2_uuid = Rails.cache.read('player2')
      		Game.start(player1_uuid, player2_uuid, uuid)
      		Rails.cache.write("people", nil)
	    end  	
    end
end
