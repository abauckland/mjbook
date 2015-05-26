$(document).ready(function(){

	$('input#quote_content_blank').click(function (){
		$('select#quote_quoteterm_id').removeAttr('disabled');
	  	$('select#clone_quote').attr('disabled', 'disabled');
	});
	
	$('input#quote_content_clone_quote').click(function (){
		$('select#clone_quote').removeAttr('disabled');
	  	$('select#quote_quoteterm_id').attr('disabled', 'disabled');
	});

});