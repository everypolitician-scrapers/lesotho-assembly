#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'

require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def scrape_list(url)
  noko = noko_for(url)
  noko.css('#ja-content table tr').drop(1).each do |row|
    tds = row.css('td')
    data = { 
      name: tds[0].text.sub('Mohl. ','').strip,
      area: tds[1].text.strip,
      party: tds[3].text.strip,
      term: 9,
      source: url,
    }
    next if data[:name].empty?
    puts data
    ScraperWiki.save_sqlite([:name, :term], data)
  end
end

term = {
  id: 9,
  name: '9th Parliament',
  start_date: '2015-03-10',
  source: 'http://www.parliament.ls/assembly/index.php?option=com_content&view=article&id=143:10th-march-2015&catid=61:hansard&Itemid=70',
}
ScraperWiki.save_sqlite([:id], term, 'terms')

scrape_list('http://www.parliament.ls/assembly/index.php?option=com_content&view=article&id=37&Itemid=56')
