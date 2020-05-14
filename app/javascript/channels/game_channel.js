import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
  	$('#dice').hide()
  	$('#answerChoices').hide()
  	$('#endTurn').hide()
  	alert('connected')
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
    	case "private_message":
    		alert(data['message'])
    	break
    	case "add_cards":
    		$('#cards').append(data['msg']+"<br>")
    	break

    	case "check_rumor":
    		if(data['rumor'].length === 0)
    			alert("array is empty")
    		else
    			$('#answerChoices').show()
    			for(var i = 0; i < data['rumor'].length; i++) {
    				alert(data['rumor'][i])
    			}

    			// data['rumor']
    			// alert(new_options[0])
				// $('#answerChoices').empty()
				// $each(new_options, function(value) {
    				//new Element('option')
        			//.set('text', value)
        			//.inject($('#answerChoices'));
				//});
    	break
 		case "end_turn":
 			$('#endTurn').show()
 		break

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
