# markium

Inline [markdown][] formatting and [pygments][] syntax highlighting plugin for the [Adium][] chat client.

>**FAIR WARNING:** I don't claim to know what the hell I'm doing in Objective-C *or* Cocoa or even XCode. Use at your own risk.

##Screenie

<center>
![markium](http://alampros.github.com/markium/img/screen1.PNG)
</center>

###Features

* Markdown formatting and code syntax highlighting in your chat windows
* Inline `code` elements and quit **bold**, *italic* and ~~strikethrough~~ formatting
* Uses [redcarpet][] Yay! Github-flavored Markdown!
* Fenced code blocks (<code>```</code>: triple-tick) with language specification


##Why?

I'm a web developer. I chat a lot with other developers. Textual conversation and programming vocabulary can get very dicey ("put this before this. No, *that*, not *this*!"). Inline `code` references and [GFM][] make the task of talking about `code` a *whole lot* **easier**.

##Waaay Beta

Like I said, I'm a web developer (+designer) - this is my first dive into ObjC and the water is cold. I am 100% certain there are better ways to get the results (probably better results, too); I'm just not good enough. Please – by all means – fork me and right all the evils I have committed!

##On the Shoulders of Abnormally Tall Projects

I just put together these awesomely cool pieces:

* [Adium][]
* [redcarpet][]: Github-flavored markdown
* [pygments][]: Syntax highlighting
* [Gaia][]: MessageView Style for Adium
* [HTMLParser][]: Ben Reeves' ObjC library

#Installation

Quite a few nasty prerequisites, but the basics go like this:

1. Install the gems [redcarpet][], [albino][], and [nokogiri][]

	```bash
	$ gem install redcarpet albino nokogiri
	```
2. Install [pygments][]

	```bash
	$ easy_install Pygments
	```
3. Open `markium.AdiumMessageView` to install the MessageView Style Xtra
4. Open `bin/markium.AdiumPlugin` to install the ContentFilter plugin (requires Adium restart)
5. Activate the MessageView Style `Preferences->Messages` and select one of the `3.x` variants. Make sure that *"Show received message fonts"* and *"Show received message colors"* are both **enabled**.

#Using with Other Styles

The `AIHTMLContentFilter` method that is used to alter HTML displayed text **only works with certain styles**. The `MessageViewVersion` (listed in the view's plist) value for the style must be set to `4`. Don't ask me why, there is almost no documentation on the different `MessageViewVersion`s (I had to traipse through Adium's source to figure it out). If you want to see if your favorite MessageView Style will support it, right click on the package (usually located in `~/Library/Application Support/Adium 2.0/Message Styles/`), select *"Show Package Contents"* and open `Content/info.plist` in an editor. Look for:

```xml
...
<key>MessageViewVersion</key>
<integer>4</integer>
...
```

###CSS Additions for Syntax Highlighting

If you want to enable syntax highlighting in your MessageView Style, you can copy and `#import` the [markdown_additions.css](https://github.com/alampros/markium/blob/master/markium.AdiumMessageStyle/Contents/Resources/markdown_additions.css) file to your own style from:

```bash
/markium.AdiumMessageStyle/Contents/Resources/markdown_additions.css
```

#To Do

1. Get help making more of this thing self-contained and less reliant on other packages/languages.
2. Add markdown additions css to more MessageView Styles
3. Auto-inline images?
4. Unit tests



[markdown]: http://daringfireball.net/projects/markdown/
[pygments]: http://pygments.org/
[Adium]: http://adium.im/
[GFM]: github.github.com/github-flavored-markdown/
[redcarpet]: https://github.com/tanoku/redcarpet
[Gaia]: http://www.adiumxtras.com/index.php?a=xtras&xtra_id=4499
[HTMLParser]: https://github.com/zootreeves/Objective-C-HMTL-Parser
[albino]: https://github.com/github/albino
[nokogiri]: https://github.com/tenderlove/nokogiri



