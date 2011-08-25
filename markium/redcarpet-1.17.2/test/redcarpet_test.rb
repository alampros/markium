# encoding: utf-8
rootdir = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift "#{rootdir}/lib"

require 'test/unit'
require 'redcarpet'

class RedcarpetTest < Test::Unit::TestCase
  def test_that_discount_does_not_blow_up_with_weird_formatting_case
    text = (<<-TEXT).gsub(/^ {4}/, '').rstrip
    1. some text

    1.
    TEXT
    Redcarpet.new(text).to_html
  end

  def test_that_smart_converts_double_quotes_to_curly_quotes
    rd = Redcarpet.new(%("Quoted text"), :smart)
    assert_equal %(<p>&ldquo;Quoted text&rdquo;</p>\n), rd.to_html
  end

  def test_that_smart_converts_double_quotes_to_curly_quotes_before_a_heading
    rd = Redcarpet.new(%("Quoted text"\n\n# Heading), :smart)
    assert_equal %(<p>&ldquo;Quoted text&rdquo;</p>\n\n<h1>Heading</h1>\n), rd.to_html
  end

  def test_that_smart_converts_double_quotes_to_curly_quotes_after_a_heading
    rd = Redcarpet.new(%(# Heading\n\n"Quoted text"), :smart)
    assert_equal %(<h1>Heading</h1>\n\n<p>&ldquo;Quoted text&rdquo;</p>\n), rd.to_html
  end

  def test_that_smart_gives_ve_suffix_a_rsquo
    rd = Redcarpet.new("I've been meaning to tell you ..", :smart)
    assert_equal "<p>I&rsquo;ve been meaning to tell you ..</p>\n", rd.to_html
  end

  def test_that_smart_gives_m_suffix_a_rsquo
    rd = Redcarpet.new("I'm not kidding", :smart)
    assert_equal "<p>I&rsquo;m not kidding</p>\n", rd.to_html
  end

  def test_that_smart_gives_d_suffix_a_rsquo
    rd = Redcarpet.new("what'd you say?", :smart)
    assert_equal "<p>what&rsquo;d you say?</p>\n", rd.to_html
  end

  if "".respond_to?(:encoding)
    def test_should_return_string_in_same_encoding_as_input
      input = "Yogācāra"
      output = Redcarpet.new(input).to_html
      assert_equal input.encoding.name, output.encoding.name
    end
  end

  def test_that_no_image_flag_works
    rd = Redcarpet.new(%(![dust mite](http://dust.mite/image.png) <img src="image.png" />), :no_image)
    assert rd.to_html !~ /<img/
  end

  def test_that_no_links_flag_works
    rd = Redcarpet.new(%([This link](http://example.net/) <a href="links.html">links</a>), :no_links)
    assert rd.to_html !~ /<a /
  end

  def test_that_strict_flag_works
    rd = RedcarpetCompat.new("foo_bar_baz", :strict)
    assert_equal "<p>foo<em>bar</em>baz</p>\n", rd.to_html
  end

  def test_that_autolink_flag_works
    rd = Redcarpet.new("http://github.com/rtomayko/rdiscount", :autolink)
    assert_equal "<p><a href=\"http://github.com/rtomayko/rdiscount\">http://github.com/rtomayko/rdiscount</a></p>\n", rd.to_html
  end

  def test_that_safelink_flag_works
    rd = Redcarpet.new("[IRC](irc://chat.freenode.org/#freenode)", :safelink)
    assert_equal "<p>[IRC](irc://chat.freenode.org/#freenode)</p>\n", rd.to_html
  end

  def test_that_tags_can_have_dashes_and_underscores
    rd = Redcarpet.new("foo <asdf-qwerty>bar</asdf-qwerty> and <a_b>baz</a_b>")
    assert_equal "<p>foo <asdf-qwerty>bar</asdf-qwerty> and <a_b>baz</a_b></p>\n", rd.to_html
  end
  
  def xtest_pathological_1
    star = '*'  * 250000
    Redcarpet.new("#{star}#{star} hi #{star}#{star}").to_html
  end

  def xtest_pathological_2
    crt = '^' * 255
    str = "#{crt}(\\)"
    Redcarpet.new("#{str*300}").to_html
  end

  def xtest_pathological_3
    c = "`t`t`t`t`t`t" * 20000000
    Redcarpet.new(c).to_html
  end

  def xtest_pathological_4
    Redcarpet.new(" [^a]: #{ "A" * 10000 }\n#{ "[^a][]" * 1000000 }\n").to_html.size
  end

  def test_link_syntax_is_not_processed_within_code_blocks
    markdown = Markdown.new("    This is a code block\n    This is a link [[1]] inside\n")

    assert_equal "<pre><code>This is a code block\nThis is a link [[1]] inside\n</code></pre>\n",
      markdown.to_html
  end

  def test_that_generate_toc_sets_toc_ids
    rd = Redcarpet.new("# Level 1\n\n## Level 2", :generate_toc)
    assert rd.generate_toc
    assert_equal %(<h1 id="toc_0">Level 1</h1>\n\n<h2 id="toc_1">Level 2</h2>\n), rd.to_html
  end

  def test_should_get_the_generated_toc
    rd = Redcarpet.new("# Level 1\n\n## Level 2", :generate_toc)
    exp = %(<ul>\n<li><a href="#toc_0">Level 1</a></li>\n<li><ul>\n<li><a href="#toc_1">Level 2</a></li>\n</ul></li>\n</ul>)
    assert_equal exp, rd.toc_content.strip
  end

  def test_whitespace_after_urls
    rd = Redcarpet.new("Japan: http://www.abc.net.au/news/events/japan-quake-2011/beforeafter.htm (yes, japan)", :autolink)
    exp = %{<p>Japan: <a href="http://www.abc.net.au/news/events/japan-quake-2011/beforeafter.htm">http://www.abc.net.au/news/events/japan-quake-2011/beforeafter.htm</a> (yes, japan)</p>}
    assert_equal exp, rd.to_html.strip
  end

  def test_unbound_recursion
    Redcarpet.new(("[" * 10000) + "foo" + ("](bar)" * 10000)).to_html
  end

  def test_memory_leak_when_parsing_char_links
    Redcarpet.new(<<-leaks).to_html
2. Identify the wild-type cluster and determine all clusters
   containing or contained by it:
   
       wildtype <- wildtype.cluster(h)
       wildtype.mask <- logical(nclust)
       wildtype.mask[c(contains(h, wildtype),
                       wildtype,
                       contained.by(h, wildtype))] <- TRUE
  
   This could be more elegant.
    leaks
  end

  def test_infinite_loop_in_header
    assert_equal Redcarpet.new(<<-header).to_html.strip, "<h1>Body</h1>"
######
#Body#
######
    header
  end

  def test_that_tables_flag_works
    text = <<EOS
 aaa | bbbb
-----|------
hello|sailor
EOS

    assert Redcarpet.new(text).to_html !~ /<table/
    assert Redcarpet.new(text, :tables).to_html =~ /<table/
  end

  def test_strikethrough_flag_works
    text = "this is ~some~ striked ~~text~~"
    assert Redcarpet.new(text).to_html !~ /<del/
    assert Redcarpet.new(text, :strikethrough).to_html =~ /<del/
  end

  def test_that_fenced_flag_works
    text = <<fenced
This is a simple test

~~~~~
This is some awesome code
    with tabs and shit
~~~
fenced

    assert Redcarpet.new(text).to_html !~ /<code/
    assert Redcarpet.new(text, :fenced_code).to_html =~ /<code/
  end

  def test_that_gh_blockcode_works
    text = <<fenced
~~~~~ {.python .numbered}
This is some unsafe code block
    with custom CSS classes
~~~~~
fenced

    assert Redcarpet.new(text, :fenced_code).to_html =~ /<code class/
    assert Redcarpet.new(text, :fenced_code, :gh_blockcode).to_html !~ /<code class/
  end

  def test_that_compat_is_working
    rd = RedcarpetCompat.new(<<EOS)
 aaa | bbbb
-----|------
hello|sailor

This is ~~striked through~~ test
EOS
    assert rd.tables
    assert rd.to_html =~ /<table/
    assert rd.to_html =~ /<del/
  end

  def test_that_headers_are_linkable
    markdown = Redcarpet.new('### Hello [GitHub](http://github.com)')
    assert_equal "<h3>Hello <a href=\"http://github.com\">GitHub</a></h3>", markdown.to_html.strip
  end

  def test_autolinking_with_ent_chars
    markdown = Redcarpet.new(<<text, :autolink)
This a stupid link: https://github.com/rtomayko/tilt/issues?milestone=1&state=open
text
    assert_equal "<p>This a stupid link: <a href=\"https://github.com/rtomayko/tilt/issues?milestone=1&state=open\">https://github.com/rtomayko/tilt/issues?milestone=1&amp;state=open</a></p>\n", markdown.to_html
  end

  def test_hard_wrap
    rd = Redcarpet.new(<<text, :hard_wrap)
This is just a test
this should have a line break

This is just a test.
text
  
    assert rd.to_html =~ /<br>/
  end

  def test_spaced_headers
    rd = Redcarpet.new("#123 a header yes\n", :space_header)
    assert rd.to_html !~ /<h1>/
  end
end
