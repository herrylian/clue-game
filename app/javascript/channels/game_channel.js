import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
    alert('connected')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	switch(data['action']) {
  		case "hide":
    		alert('Received the following message: '+data['msg'])
    		
    			$('p').hide()
    		break
    	case "none":
    		alert('Received the following message: '+data['msg']+'youre good!')
    		break
  	}
  }
});
