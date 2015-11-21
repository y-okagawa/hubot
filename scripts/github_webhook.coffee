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


    # wiki = wiki + "#{req.body.pages[0].page_name}\r\n"
    # wiki = wiki + "#{req.body.pages[0].html_url}\r\n"

    robot.send {room: 'general'}, getWikiContent req.body

    res.send "ok"


getWikiContent = (json) ->
  action = json.pages[0].action
  switch action
    when 'create'
      wiki = """
        GitHub Wiki Create\r\n
      """
    when 'edit'
      wiki = """
        GitHub Wiki Update\r\n
      """



isCorrectSignature = (signature, body) ->
  pairs = signature.split '='
  digest_method = pairs[0]
  hmac = crypto.createHmac digest_method, process.env.HUBOT_GITHUB_SECRET
  hmac.update JSON.stringify(body), 'utf-8'
  hashed_data = hmac.digest 'hex'
  generated_signature = [digest_method, hashed_data].join '='

  return signature is generated_signature

tweetForPullRequest = (json) ->
  action = json.action
  pr = json.pull_request

  switch action
    when 'opened'
      "#{pr.user.login}さんからPull Requestをもらいました #{pr.title} #{pr.html_url}"
    when 'closed'
      if pr.merged
        "#{pr.user.login}さんのPull Requestをマージしました #{pr.title} #{pr.html_url}"

tweetForIssues = (json) ->
  action = json.action
  issue = json.issue

  switch action
    when 'opened'
      "#{issue.user.login}さんがIssueを上げました #{issue.title} #{issue.html_url}"
    when 'closed'
      "#{issue.user.login}さんのIssueがcloseされました #{issue.title} #{issue.html_url}"

