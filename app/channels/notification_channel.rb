class NotificationChannel < ApplicationCable::Channel
  def subscribed
     stream_from "global_channel"
     # stream_from "player_#{uuid}}"
     
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
