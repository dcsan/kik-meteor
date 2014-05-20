
Template.home.greeting = () ->
	return "ready to play"

Template.home.events
	'click input': () ->
		console.log('click')
