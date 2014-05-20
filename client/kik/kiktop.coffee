@msgCount = 0


Template.kiktop.getMessage = () ->
  return Session.get('msg')

debugMsg = (msg, v1='', v2='' ) ->
  str = msg + JSON.stringify(v1)
  console.log(msg, v1, v2)
  Session.set('msg', str)


sendKik = ->
  kik.push.getToken (token) ->
    if token
      console.log "got token"    
    # success, send the token to your server
    # typeof token === 'string'
    else
      console.log "no toekn"


# failed to receive token, retry later
kikInit = ->
  kik.getUser (user) ->
    unless user
      
      # user denied access to their information
      console.log "failed"
    else
      # typeof user.username # 'string'
      # typeof user.fullName # 'string'
      # typeof user.firstName # 'string'
      # typeof user.lastName # 'string'
      # typeof user.pic # 'string'
      # typeof user.thumbnail # 'string'
      console.log "user", user


userInfo = ->
  kik.getUser (user) ->
    console.log('userInfo', user)

pickFriends = ->
  kik.pickUsers (users) ->
    unless users
      console.log "pickFriends - no users"
    
    # action was cancelled by user
    else
      users.forEach (user) ->
        console.log('pick', user)

sendMsg = () ->
  msgTitle = "message #{msgCount}"
  msgCount++

  res = kik.send({
    title     : 'pic image',
    text      : 'Message body',
    # pic: 'http://mkalty.org/wp-content/uploads/2014/03/cats_animals_kittens_cat_kitten_cute_desktop_1680x1050_hd-wallpaper-753974.jpeg'
    # pic       : 'http://mysite.com/pic' ,
    # big       : true,
    # noForward : true,
    # data      : { some : 'json' }
  });
  console.log('sent res=', res)

openChat = () ->
  kik.openConversation('kikteam');


pickPhoto = () ->
  kik.photo.get (photos) ->
    unless photos
      console.log "got photos - cancelled"
    else
      console.log "got photos"
    return

getToken = () ->
  kik.push.getToken (token) ->
    if token
      debugMsg "got token", token
      Session.set('pushToken', token)
      # pushToken = token
      # success, send the token to your server
      # typeof token === 'string'
    else
      console.log "failed token"
    return

sendPush = () ->
  token = Session.get('pushToken')
  debugMsg 'sendPush', token
  res = Meteor.call('serverPush', token)
  debugMsg 'sendPush res', res


Template.kiktop.events = 
  "click #kikInit": (e) ->
    console.log('kikInit')
    kikInit()

  "click #userInfo": (e) ->
    console.log('userInfo')
    userInfo()

  "click #pickFriends": (e) ->
    console.log('pickFriends')
    pickFriends()

  "click #sendMsg": (e) ->
    console.log('sendMsg')
    sendMsg()

  "click #openChat": (e) ->
    console.log('openChat...')
    openChat()

  "click #showProfile": (e) ->
    kik.showProfile('kikteam');

  "click #pickPhoto": (e) ->
    pickPhoto()

  "click #getToken": (e) ->
    getToken()

  "click #sendPush": (e) ->
    sendPush()

# window.kikInit = kikInit

pageInit = () ->
  console.log("kiktop.pageInit")
  kik.browser.statusBar(false)


Template.kiktop.rendered = ->
  debugMsg('kiktop rendered')

  # hmm, has to be defined after kik is loaded
  kik.ready ->
    console.log("kik called ready callback")

  kik.push.handler (data) ->
    # this function will run for every push received
    # 'data' is the parsed JSON object specified in your push
    # example from above: data === { 'your' : 'json_object' }
    debugMsg('push.handler', data)
