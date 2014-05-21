Router.configure 
	layoutTemplate: "layout"


Router.map ->
	
	@route "home",
		path: "/"

	@route 'kiktop',
		path: '/kiktop'