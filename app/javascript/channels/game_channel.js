import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
    
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	switch(data['action']) {
  		case "hide":
    		alert('Received the following message: '+data['msg']);
    		$('p').hide()
    	break
    	case "unhide":
    		alert('Received the following message: '+data['msg']+'youre good!')
    		$('p').show()
    	break
    	case "set_identity":
    		console.log("got to the set_identity part") 
    		document.cookie = 'player='+data['msg']+'; uuid='+data['uuid']
    		console.log("got after it") 
    	break
  	}
  }
});
