module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :uuid

    def connect
      self.uuid = SecureRandom.urlsafe_base64
      hello = 'user ID is ' + uuid
      puts hello
    end
  end
end