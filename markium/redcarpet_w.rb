#!/usr/bin/ruby
require 'rubygems'
require 'redcarpet'
require 'Pygments'

class HTMLwithPygments < Redcarpet::Render::XHTML
	# def doc_header()
	#	puts Pygments.styles()
	# monokai
	# manni
	# perldoc
	# borland
	# colorful
	# default
	# murphy
	# vs
	# trac
	# tango
	# fruity
	# autumn
	# bw
	# emacs
	# vim
	# pastie
	# friendly
	# native
	# 	'<style>' + Pygments.css('.highlight',:style => 'vs') + '</style>'
	# end
	def block_code(code, language)
		Pygments.highlight(code, :lexer => language, :options => {:encoding => 'utf-8'})
	end
end


def fromMarkdown(text)
	markdown = Redcarpet::Markdown.new(HTMLwithPygments,
						     :fenced_code_blocks => true,
						     :no_intra_emphasis => true,
						     :autolink => true,
						     :strikethrough => true,
						     :lax_html_blocks => true,
						     :superscript => true,
						     :hard_wrap => true,
						     :tables => true,
						     :xhtml => true)
	markdown.render(text)
end

puts fromMarkdown(ARGF.read)