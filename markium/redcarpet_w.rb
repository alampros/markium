#!/usr/bin/env ruby

require 'rubygems'
require 'redcarpet'
require 'albino'
require 'nokogiri'

def markdown(text)
  options = [:fenced_code,:no_intraemphasis,:strikethrough,:gh_blockcode,:tables,:hard_wrap,:lax_htmlblock,:xhtml,:autolink]
  html = Redcarpet.new(text, *options).to_html 
  syntax_highlighter(html)
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.at_css("body").inner_html.to_s
end

puts markdown(ARGF.read)