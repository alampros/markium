var init = function(){
	$$('a').each(function(el){
		var link_text = el.getText();
		var link_url = el.getProperty('href');
	
		var link_rep = new Element('a', {
			'class': 'button',
			'title': link_text,
			'href': link_url
		});

		var link_inner = new Element('span', {
			'class': 'js'	
		}).injectInside(link_rep);
		
		var link_hide = new Element('span', {
			'class': 'rep'	
		}).injectInside(link_inner).appendText(link_text);
	
		el.replaceWith(link_rep);
	});
	
	/*var myTips = new Tips($$('a'), {
		showDelay: 500,
		hideDelay: 50
	});*/ 
	//Maybe Later!
}