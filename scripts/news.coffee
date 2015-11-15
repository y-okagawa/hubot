client = require('cheerio-httpcli')

module.exports = (robot) ->
  robot.respond /yahooニュース/i, (res) ->
    client.fetch 'http://www.yahoo.co.jp/', {}, (err, $, sc)->
      news = ""
      $('ul.emphasis > li > a').each ()-> # jQueryライクに要素を検索できる!!
        news = news + $(this).text() + "¥n"

    res.send news

