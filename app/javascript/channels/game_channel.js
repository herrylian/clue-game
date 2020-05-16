import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
  	$('#dice').hide()
  	$('#answerChoices').hide()
  	$('#endTurn').hide()
  	$('#rumorDropdowns').hide()
  	$('#passButton').hide()
    $('#skipToNextPlayerButton').hide()
  	alert('connected')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	switch(data['action']) {
    	case "set_identity":
    		document.cookie = 'uuid='+data['msg']
    		$('#name_field').hide() 
    	break
    	case "start_turn":
    		//  Set boolean for them to be true
    		//  jquery - Tell them it's their turn. 
    		$('#text_box').append("It's your turn. Roll the dice."+"<br>")
    		$('#dice').show() 
    	break
    	case "move":
    		$('#text_box').append('You rolled a '+data['msg']+".<br>")
    		$('#dice').hide() 
    		// (determine location, coordinates)
    		// Javascript make move. -> pick choice, back to welcome controller. 
    		$('#rumorDropdowns').show()
    	break
    	case "send_message":
    		$('#text_box').append(data['player_name']+" said: "+data['message']+"<br>")
    	break
    	case "private_message":
    		$('#text_box').append(data['message']+"<br>")
    	break
    	case "add_cards":
    		$('#cards').append(data['msg']+"<br>")
    	break

    	case "check_rumor":
    		if(data['rumor'].length === 0)
    			if(data['last'] === 'false')
            $('#skipToNextPlayerButton').show()
          else 
            $('#passButton').show()
    		else
    			$('#answerChoices').show()
    			for(var i = 0; i < data['rumor'].length; i++) {
    				$('#text_box').append(data['rumor'][i]+"<br>")
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
 			$('#rumorDropdowns').hide()
 			$('#endTurn').show()
 		break
 		case "hide_pass_button":
 			$('#passButton').hide()
 		break
 		case "hide_end_turn_button":
 			$('#endTurn').hide()
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
