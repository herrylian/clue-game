import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
  	$('#dice').hide()
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	switch(data['action']) {
    	case "set_identity":
    		document.cookie = 'uuid='+data['msg']
    	break
    	case "start_turn":
    		//  Set boolean for them to be true
    		//  jquery - Tell them it's their turn. 
    		alert("it's your turn. roll the dice")
    		$('#dice').show() 
    	break
    	case "move":
    		alert('You rolled a '+data['msg'])
    		$('#dice').hide() 
    		// (determine location, coordinates)
    		// Javascript make move. -> pick choice, back to welcome controller. 
    	break
    	case "send_message":
    		alert(data['player_name']+" said: "+data['message'])
    	break
    	

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
    	// case "hide":
    		//alert('Received the following message: '+data['msg']);
    		//$('p').hide()
    	//break
    	//case "unhide":
    		//alert('Received the following message: '+data['msg'])
    		//$('p').show()
    	//break
  	}
  }
});
