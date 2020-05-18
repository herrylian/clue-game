import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
  	$('#dice').hide()
  	$('#answerChoices').hide()
  	$('#endTurn').hide()
  	$('#rumorDropdowns').hide()
  	$('#passButton').hide()
    $('#skipToNextPlayerButton').hide()
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	switch(data['action']) {
    	case "set_identity":
    		document.cookie = 'uuid='+data['uuid']
    	break

      case "add_cards":
        $('#cards').append(data['cards']+"<br>")
      break

    	case "start_turn": 
    		$('#text_box').append("Game announce said: It's your turn. Roll the dice."+"<br>")
    		$('#dice').show() 
    	break

    	case "move":
    		$('#text_box').append('Game announce said: You rolled a '+data['msg']+".<br>")
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
    	
    	case "check_rumor":
    		if(data['rumor'].length === 0) {
    			if(data['last'] === 'false') {
            $('#skipToNextPlayerButton').show()
            $('#text_box').append("Game Announcer said: You don't have any of these cards. Skip. <br>")
          }
          else {
            $('#text_box').append("Game Announcer said: You don't have any of these cards. Pass. <br>");
            $('#passButton').show()
          }
        }
    		else {
    			$('#answerChoices').show()
    			for(var i = 0; i < data['rumor'].length; i++) {
    				$('#text_box').append("Game Announcer said: You have "+data['rumor'][i]+"<br>")
    			}
          $('#text_box').append("Game Announcer said: Choose which card to show. <br>")
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
 		case "hide_name_field":
      $('#name_field').hide()
    break
    case "hide_pass_button":
 			$('#passButton').hide()
 		break
    case "hide_skip_button":
      $('#skipToNextPlayerButton').hide()
    break
    case "hide_answer_button":
      $('#answerChoices').hide()
    break
 		case "hide_end_turn_button":
 			$('#endTurn').hide()
 		break
    case "clear_text_input":
      $("input:text").val("")
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
