client = require('cheerio-httpcli')

news = ""
module.exports = (robot) ->
  robot.respond /yahooニュース/i, (res) ->
    client.fetch 'http://www.yahoo.co.jp/', {}, (err, $, sc)->
      $('ul.emphasis > li > a').each ()-> # jQueryライクに要素を検索できる!!
        news = news + $(this).text() + "¥n"
      res.send news

