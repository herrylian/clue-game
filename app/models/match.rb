class Match < ApplicationRecord
	def self.create(uuid)
    	if Rails.cache.read("people").blank?
    		Rails.cache.write("people", 1)
    		Rails.cache.write('Player1', uuid)
    	else
    		# Get the uuid of the player waiting
      		people = Rails.cache.read("people")
      		Rails.cache.write("people", people+1)
	  		Rails.cache.write('Player2', uuid)
	  		player1_uuid = Rails.cache.read('Player1')
	  		player2_uuid = Rails.cache.read('Player2')
      		Game.start(player1_uuid, player2_uuid)
      		Rails.cache.write("people", nil)
    end
  end
end
