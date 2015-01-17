$(document).ready(function(){

// update category
	$('.inline_cat').mouseover(function(){
	var line_id = $(this).attr('id');	
		$(this).editable('mjbook/inlines/'+line_id+'/update_cat', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl : 'mjbook/productcategories/'+line_id+'/cat_options',
			type: 'comboselect',
			ajaxoptions: {dataType: 'script'},
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 		 
	});

// update item	
	$('.inline_item').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_item', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl : 'mjbook/products/'+line_id+'/invoice_item_options',
			type: 'comboselect',
			ajaxoptions: {dataType: 'script'},
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		});	
	});

// update item	
	$('.inline_cat_item').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_cat_item', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl : 'mjbook/products/'+line_id+'/invoice_item_options',
			type: 'comboselect',
			ajaxoptions: {dataType: 'script'},
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		});	
	});


// update quantity	
	$('.inline_quantity').mouseover(function(){
	var line_id = $(this).attr('id');	
		$(this).editable('mjbook/inlines/'+line_id+'/update_quantity', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text',
			ajaxoptions: {dataType: 'script'},
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 
	});

// update unit	
	$('.inline_unit').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_unit', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl :'mjbook/units/'+line_id+'/unit_options',
			type: 'select',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});

// update rate	
	$('.inline_rate').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_rate', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text',
			ajaxoptions: {dataType: 'script'},
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});

// update vat rate	
	$('.inline_vat_rate').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_vat_rate', {
			id: line_id, width: ($(this).width() +10)+'px',
			loadurl :'/mjbook/vats/'+line_id+'/vat_options',
			type: 'select',
			ajaxoptions: {dataType: 'script'},
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});

// update vat due	
	$('.inline_vat_due').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_vat_due', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'text',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});


// update text	
	$('.inline_text').mouseover(function(){
	var line_id = $(this).attr('id');
		$(this).editable('mjbook/inlines/'+line_id+'/update_text', {
			id: line_id, width: ($(this).width() +10)+'px',
			type: 'autogrow',
			onblur: 'submit',
			method: 'PUT',
			indicator: 'Saving..',
			submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
		}); 	
	});

});
