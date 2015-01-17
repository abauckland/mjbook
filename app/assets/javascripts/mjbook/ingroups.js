$(document).ready(function(){

	$('.ingroup_text').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('https://www.myhq.org.uk/mjbook/ingroups/'+line_id+'/update_text', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});

});