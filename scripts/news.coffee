client = require('cheerio-httpcli')

module.exports = (robot) ->
  robot.respond /yahoo (.*)/i, (res) ->
    news = ""
    switch res.match[1]
      when '経済'
        param = 'hl?c=bus'
      when 'エンタメ'
        param = 'hl?c=c_ent'
      when 'スポーツ'
        param = 'hl?c=c_spo'
      else
        param = ''
    client.fetch 'http://news.yahoo.co.jp/' + param, {}, (err, $, sc)->
      news = $('.topics > li > div > h1 > a').text() + "\r\n"
      news = $('.topics > li > div > h1 > a').attr("href") + "\r\n"
      $('.topics > li > div > p > a').each ()->
        news = news + $(this).text() + "\r\n"
        news = news + $(this).attr("href") + "\r\n"
      res.send news

