# Description:
#   Listens and pushes all messages to a logger
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_LOGGER_API_KEY
#   HUBOT_LOGGER_URL
#
# Commands:
#   None
#
# Author:
#   cpradio

module.exports = (robot) ->

  channels = {
      'C04RY7CHU': 'bot-experiments',
      'C0444JE25': 'general',
      'G04L8UTKT': 'disaster-control',
      'G04L8V9EZ': 'spf-advisors',
      'G06PELB55': 'spf-mentors',
      'G04L8UPLM': 'tl-admins'
    }

  robot.hear /(.*)/, (msg) ->
    channel = channels[msg.message.room]

    data = JSON.stringify( {
        'api_key': process.env.HUBOT_LOGGER_API_KEY,
        'user_id': msg.message.user.id.toUpperCase(),
        'room': channel,
        'username': msg.message.user.name,
        'real_name': msg.message.user.real_name,
        'message': msg.message.text
    })
    console.log data
    console.log process.env.HUBOT_LOGGER_URL

    WHITELIST_ROOMS = /(general|bot-experiments|disaster-control|spf-advisors|spf-mentors)/ig
    if WHITELIST_ROOMS.test(channel)
      console.log channel
      msg.http(process.env.HUBOT_LOGGER_URL)
          .header('Content-Type', 'application/json')
          .post(data) (err, res, body) ->
              console.log err
              console.log body
              return
