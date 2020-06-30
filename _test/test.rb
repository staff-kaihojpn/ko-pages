require 'time'
require 'open-uri'
require 'nokogiri'

def test
  p(Date.today)
  p(Time.at(Time.now.to_i,in: "+09:00").strftime("%Y-%m-%d"))
end

def generate
  auction_id = "galleriaricho"
  html = open("https://auctions.yahoo.co.jp/seller/galleriaricho?n=100&sid="+auction_id+"&b=1&s1=end&o1=a&mode=1&anchor=1").read
  items = []

  doc = Nokogiri::HTML.parse(html, nil, nil)
  doc.css('#list01 > div.inner.cf > div.bd.cf').each do |entry_elem|
    today = Date.parse(Time.at(Time.now.to_i,in: "+09:00").strftime("%Y-%m-%d"))
    etm = Time.at((entry_elem.at_css('div.a.cf > h3 > a').attributes['data-ylk'].value).match('etm=([0-9]+),')[1].to_i, in: "+09:00")
    edt = Date.parse(etm.strftime("%Y-%m-%d"))
    if edt < today then
      next
    elsif edt > today then
      break
    end
    items.push({
      "title": entry_elem.at_css('div.a.cf > h3 > a').content, 
      'image': entry_elem.at_css('div img').attributes['src'].value,
      'url': entry_elem.at_css('div.a.cf > h3 > a').attributes['href'].value,
    })
  end
  p(items.size)

  # レイアウト側で使えるようにsite.dataに値を入れておく
  # site.data.merge!({ "items" => items })
end

generate
#test