import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
    $('p').hide()
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	switch(data['action']) {
  		case "hide":
    		alert('Received the following message: '+data['msg']);
    		break
    	case "none":
    		alert('Received the following message: '+data['msg']+'youre good!')
    		break
  	}
  }
});
