# Description:
# GitHub Webhookのエンドポイント
#
# Notes:
# wikiが対象
crypto = require 'crypto'

module.exports = (robot) ->
  robot.router.post "/github/webhook", (req, res) ->
    event_type = req.get 'X-Github-Event'
    signature = req.get 'X-Hub-Signature'

    unless isCorrectSignature signature, req.body
      res.status(401).send 'unauthorized'
      return

    robot.send {room: 'general'}, getWikiContent req.body.pages[0]
    res.send "ok"

getWikiContent = (json) ->
  switch json.action
    when 'created'
      """
      Github Wiki Created
      >TITLE：#{json.title}
      >URL：#{json.html_url}
      """
    when 'edited'
      """
      Github Wiki Updated
      >TITLE#{json.title}
      >URL：#{json.html_url}
      """

isCorrectSignature = (signature, body) ->
  pairs = signature.split '='
  digest_method = pairs[0]
  hmac = crypto.createHmac digest_method, process.env.HUBOT_GITHUB_SECRET
  hmac.update JSON.stringify(body), 'utf-8'
  hashed_data = hmac.digest 'hex'
  generated_signature = [digest_method, hashed_data].join '='

  return signature is generated_signature
