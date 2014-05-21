pushCallback = (res) ->
	console.log('pushCallback\n', res)


Meteor.startup ->
	console.log("server startup")

Meteor.methods

	serverPush: (token) ->
		pushData = {
			token: token
			ticker: "ticker me"
			data: {
				a: 'alpha'
				b: 'beta'
			}
		}

		headers = {
			'Content-Type': 'application/json; charset=utf-8'
		}
      
		# this.response.writeHead(200, {'Content-Type': 'application/json; charset=utf-8'});

		post = {
			data: pushData
			headers: headers
		}

		url = 'https://api.kik.com/push/v1/send'
		console.log('serverPush', post)
		Meteor.http.call("POST", url, post, pushCallback)
		
		# Meteor.setTimeout () ->
		# 	res = Meteor.http.call("POST", url, post, pushCallback)
		# , 3000

SeoCollection.remove({})
SeoCollection.insert({
    "route_name" : "home", 
    "title" : "KIK test",

    "meta" : [
        {"description": "testing KIK with meteor"},
    ],
})
