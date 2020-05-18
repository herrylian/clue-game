class Match < ApplicationRecord
	def self.create(uuid)
        ActionCable.server.broadcast "player_#{uuid}", {action: "set_identity", uuid: uuid}
        
    end	
end

# case Rails.cache.read("people")
