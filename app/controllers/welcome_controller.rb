class WelcomeController < ApplicationController
  def index
  end
  
  def msg
  	message = params[:q]
	Dice.create(:dice => message)
	sum = [Dice.all.count].to_s
	alert('There are now: ' + sum + 'records in the database.')
  end
end
