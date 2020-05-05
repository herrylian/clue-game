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
    	// case take_turn
    	// 	reveal the dice. 
    	//  Set boolean for them to be true
    	//  jquery - Tell them it's their turn. 
    	// This will now go to index for dice roll. 

    	// case make_move
    	//  (determine location, coordinates)
    	// Javascript make move. -> pick choice, back to welcome controller. 

    	// case start_rumor
    	// unhide rumor drodpdowns
    	// Javascript, make a move

    	// case receive_rumor_request
    	// ok this is what you've been told. Jquery
    	//  Reveal 3 buttons and corresponding choices. 
    	// Javascript file -> pick choice , choice return back to welcome controller

    	//case rumor is confirmed
    	// show the original guy. 
    	// Javascript end turn goes back to index. 
  	}
  }
});
