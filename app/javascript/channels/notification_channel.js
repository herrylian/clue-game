import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    alert('connected')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    alert('Received the following message: '+data['body'])
  }
});
