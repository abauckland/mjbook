$(document).ready(function(){

	$('.qline_cat').mouseover(function(){
	var line_id = $(this).attr('id');	
		$(this).editable('/qlines/'+line_id+'/update_cat', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl : 'http://localhost:3000/productcategories/'+line_id+'/list_categories',
			type: 'comboselect',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 		
	});
	
	$('.qline_item').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('/qlines/'+line_id+'/update_item', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl : 'http://localhost:3000/products/'+line_id+'/list_items',
			type: 'comboselect',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		});	
	});
	
	$('.qline_quantity').mouseover(function(){
	var line_id = $(this).attr('id');	
		$(this).editable('/qlines/'+line_id+'/update_quantity', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text,
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 
	});
	
	$('.qline_unit').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('/qlines/'+line_id+'/update_unit', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text,
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});
	
	$('.qline_rate').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('/qlines/'+line_id+'/update_rate', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text,
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});
	
	$('.qline_vat').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('/qlines/'+line_id+'/update_vat', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text,
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});
	
	$('.qline_text').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('/qlines/'+line_id+'/update_text', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'autogrow',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});

});