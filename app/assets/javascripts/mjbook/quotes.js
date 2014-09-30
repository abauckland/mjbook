// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//jeditbale functions
$.editable.addInputType('autogrow', {
                element : function(settings, original) {
                    var textarea = $('<textarea />');
                    if (settings.rows) {
                        textarea.attr('rows', settings.rows);
                    } else if (settings.height != "none") {
                        textarea.height(settings.height);
                    }

                   	textarea.width(settings.width);	                       	                       	

                    textarea.css("font", "normal 12px arial").css("padding-top", "0px");
                    $(this).append(textarea);
                    return(textarea);
                },
    			plugin : function(settings, original) {
        			$('textarea', this).autogrow();
    			},
});

$.editable.addInputType('comboselect', {
				element : function(settings, original) {
                    var select = $('<select />');
                    $(this).append(select);
                    return(select);
                },
                content : function(data, settings, original) {
                    /* If it is string assume it is json. */
                    if (String == data.constructor) {      
                        eval ('var json = ' + data);
                    } else {
                    /* Otherwise assume it is a hash already. */
                        var json = data;
                    }
                    for (var key in json) {
                        if (!json.hasOwnProperty(key)) {
                            continue;
                        }
                        if ('selected' == key) {
                            continue;
                        } 
                        var option = $('<option />').val(key).append(json[key]);
                        $('select', this).append(option);    
                    }
                    $('select', this).prepend('<option>{NEW ELEMENT}</option>');                    
                    /* Loop option again to set selected. IE needed this... */ 
                    $('select', this).children().each(function() {
                        if ($(this).val() == json['selected'] || 
                            $(this).text() == $.trim(original.revert)) {
                                $(this).attr('selected', 'selected');
                        }
                    });
                },
});



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