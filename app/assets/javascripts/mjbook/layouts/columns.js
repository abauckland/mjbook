//function for setting column width depending on size of window	
function column_width(s_tab, mob, limit) {

var window_width = $(window).width();

  if(window_width <= limit) {
  	var column_width = window_width-58;
  	$('.column_1, .column_2, .column_3, .column_1_2').width(column_width+'px');
  	$('.column_1, .column_2').css({'margin-right':"0px"}); 
  }  
  else if(window_width <= mob && window_width > limit) {  	
  	var column_width = ((window_width-15)/2)-43;
  	var column_3_width = window_width-60;  
	
	$('.column_1').css({'margin-right':"15px"});
	$('.column_2').css({'margin-right':"0px"}); 
  	$('.column_1, .column_2, .column_1_2').width(column_width+'px');
  	$('.column_3').css({'width': column_3_width+'px'});
  }                                                                 
  else{
  	var column_width = ((window_width-30)/3)-31; 
  	$('.column_1, .column_2, .column_3').width(column_width+'px');
	$('.column_1, .column_2').css({'margin-right':"15px"}); 
  }
}


function columns_height(s_tab, mob, limit, col_1, col_2, col_3) {

	var sub_column_location = 0;
	var footerHeight = 40;
	var window_width = $(window).width();

	if(window_width <= limit) {

  		//reset
		$('.column_1').height((col_1)+'px');
		$('.column_2').height((col_2)+'px').css({'margin-top':'10px'});		
		$('.column_3').height((col_3)+'px').css({'margin-top':'10px'});	

		if ($('.column_1').children('.column_content').children('.column_error').length){	
			var sub_column_location = $('.column_1').children('.column_content').children('.column_error').outerHeight(true) + 10;
			var footer_1_location = sub_column_location + col_1 - footerHeight;
		}else{
			var footer_1_location = sub_column_location + col_1 - footerHeight;								
		}	
		
		if ($('.column_2').children('.column_content').children('.column_error').length){	
			var sub_column_location = $('.column_2').children('.column_content').children('.column_error').outerHeight(true) + 10;
			var footer_2_location = sub_column_location + col_2 - footerHeight;
		}else{
			var footer_2_location = sub_column_location + col_2 - footerHeight;								
		}
		
		if ($('.column_3').children('.column_content').children('.column_error').length){	
			var sub_column_location = $('.column_3').children('.column_content').children('.column_error').outerHeight(true) + 10;
			var footer_3_location = sub_column_location + col_3- footerHeight;
		}else{
			var footer_3_location = sub_column_location + col_3 - footerHeight;								
		}
					
	}else if(window_width <= mob && window_width > limit) {
  		//reset				
		$('.column_3').height((col_3)+'px').css({'margin-top':'10px'}); 
		//set height	
		var highestCol = Math.max(col_1, col_2);
		$('.column_1, .column_2').height(highestCol+'px').css({'margin-top':'0px'});



		if ($('.column_1').children('.column_content').children('.column_error').length){	
			var sub_column_location = $('.column_1').children('.column_content').children('.column_error').outerHeight(true) + 10;
			var footer_1_location = sub_column_location + highestCol - footerHeight;
		}else{
			var footer_1_location = sub_column_location + highestCol - footerHeight;								
		}	
		
		if ($('.column_2').children('.column_content').children('.column_error').length){	
			var sub_column_location = $('.column_2').children('.column_content').children('.column_error').outerHeight(true) + 10;
			var footer_2_location = sub_column_location + highestCol - footerHeight;
		}else{
			var footer_2_location = sub_column_location + highestCol - footerHeight;								
		}
		
		if ($('.column_3').children('.column_content').children('.column_error').length){	
			var sub_column_location = $('.column_3').children('.column_content').children('.column_error').outerHeight(true) + 10;
			var footer_3_location = sub_column_location + col_3 - footerHeight;
		}else{
			var footer_3_location = sub_column_location + col_3 - footerHeight;								
		}


	}else{

		if ($('.column_1').children('.column_content').children('.column_error').length){
			var error_height = $('.column_1').children('.column_content').children('.column_error').outerHeight(true);
		}else{
			var error_height = 0;
		}
  		var highestCol_1 = (Math.max(col_1, col_2, col_3) + error_height);
		var footer_1_location = highestCol_1 - footerHeight;

  		$('.column_1, .column_2, .column_3').height(highestCol_1+'px').css({'margin-top':'0px'});
  		$('.column_1').children('.column_content').children('.column_sub_content').css('top', error_height+'px');

		
		if ($('.column_2').children('.column_content').children('.column_error').length){
			var error_height = $('.column_2').children('.column_content').children('.column_error').outerHeight(true);
		}else{
			var error_height = 0;
		}
  		var highestCol_2 = (Math.max(col_1, col_2, col_3) + error_height);
		var footer_2_location = highestCol_2 - footerHeight;

  		$('.column_1, .column_2, .column_3').height(highestCol_2+'px').css({'margin-top':'0px'});
  		$('.column_2').children('.column_content').children('.column_sub_content').css('top', error_height+'px');

		
		if ($('.column_3').children('.column_content').children('.column_error').length){
			var error_height = $('.column_3').children('.column_content').children('.column_error').outerHeight(true);
		}else{
			var error_height = 0;
		}
  		var highestCol_3 = (Math.max(col_1, col_2, col_3) + error_height);
		var footer_3_location = highestCol_3 - footerHeight;

  		$('.column_1, .column_2, .column_3').height(highestCol_3+'px').css({'margin-top':'0px'});
  		$('.column_3').children('.column_content').children('.column_sub_content').css('top', error_height+'px');

	}
	$('.column_1').children('.column_content').children('.column_footer').css('top', footer_1_location+'px');
	$('.column_2').children('.column_content').children('.column_footer').css('top', footer_2_location+'px');		
	$('.column_3').children('.column_content').children('.column_footer').css('top', footer_3_location+'px');
												
};


$(document).ready(function(){

	//variables for setting column widths - where 3 coloumns
	var s_tab = '1280';
	var mob = '960';
	var limit = '640';

//$large_menu: 1050px;
//$medium_menu: 800px;
//$small_menu: 400px;

	var select_count_1 = $('.column_1').find('select.full_width').length;
	var select_height_1 = select_count_1*32

	var text_field_count_1 = $('.column_1').find('.column_form_input input[type=text]').length;
	var text_field_height_1 = text_field_count_1*32

	var url_field_count_1 = $('.column_1').find('.column_form_input input[type=url]').length;
	var url_field_height_1 = url_field_count_1*32

	var file_field_count_1 = $('.column_1').find('.column_form_input input[type=file]').length;
	var file_field_height_1 = file_field_count_1*40

	var time_field_count_1 = $('.column_1').find('.column_form_input input[type=time]').length;
	var time_field_height_1 = time_field_count_1*32
	
	var date_field_count_1 = $('.column_1').find('.column_form_input input[type=date]').length;
	var date_field_height_1 = date_field_count_1*32

	var colour_field_count_1 = $('.column_1').find('.column_form_input input[type=color]').length;
	var colour_field_height_1 = colour_field_count_1*40
	
	var dd_field_count_1 = $('.column_1').find('.column_form_item_dd-select').length;
	var dd_field_height_1 = dd_field_count_1*80

	var form_button_count_1 = $('.column_1').find('.column_form_button').length;
	var form_button_height_1 = form_button_count_1*32

	var form_textarea_count_1 = $('.column_1').find('textarea').length;
	var form_textarea_height_1 = form_textarea_count_1*100
	
	var form_chart_count_1 = $('.column_1').find('.column_bar_chart').length;
	var form_chart_height_1 = form_chart_count_1*350

	var column_line_form_count_1 = $('.column_1').find('.column_line_form').length;
	var column_line_form_height_1 = column_line_form_count_1*30

	var col_1 = 40+ column_line_form_height_1 + select_height_1 + text_field_height_1 + url_field_height_1 + file_field_height_1 + time_field_height_1 + date_field_height_1 + colour_field_height_1 + dd_field_height_1 + form_button_height_1 + form_textarea_height_1 + form_chart_height_1	



	var select_count_2 = $('.column_2').find('select.full_width').length;
	var select_height_2 = select_count_2*32

	var text_field_count_2 = $('.column_2').find('.column_form_input input[type=text]').length;
	var text_field_height_2 = text_field_count_2*32

	var url_field_count_2 = $('.column_2').find('.column_form_input input[type=url]').length;
	var url_field_height_2 = url_field_count_2*32

	var file_field_count_2 = $('.column_2').find('.column_form_input input[type=file]').length;
	var file_field_height_2 = file_field_count_2*40

	var time_field_count_2 = $('.column_2').find('.column_form_input input[type=time]').length;
	var time_field_height_2 = time_field_count_2*32
	
	var date_field_count_2 = $('.column_2').find('.column_form_input input[type=date]').length;
	var date_field_height_2 = date_field_count_2*32

	var colour_field_count_2 = $('.column_2').find('.column_form_input input[type=color]').length;
	var colour_field_height_2 = colour_field_count_2*40
	
	var dd_field_count_2 = $('.column_2').find('.column_form_item_dd-select').length;
	var dd_field_height_2 = dd_field_count_2*80

	var form_button_count_2 = $('.column_2').find('.column_form_button').length;
	var form_button_height_2 = form_button_count_2*32

	var form_textarea_count_2 = $('.column_2').find('textarea').length;
	var form_textarea_height_2 = form_textarea_count_2*200
	
	var form_chart_count_2 = $('.column_2').find('.column_bar_chart').length;
	var form_chart_height_2 = form_chart_count_2*350

	var col_2 = 40+ select_height_2 + text_field_height_2 + url_field_height_2 + file_field_height_2 + time_field_height_2 + date_field_height_2 + colour_field_height_2 + dd_field_height_2 + form_button_height_2 + form_textarea_height_2 + form_chart_height_2


	var select_count_3 = $('.column_3').find('select.full_width').length;
	var select_height_3 = select_count_3*32

	var text_field_count_3 = $('.column_3').find('.column_form_input input[type=text]').length;
	var text_field_height_3 = text_field_count_3*32

	var url_field_count_3 = $('.column_3').find('.column_form_input input[type=url]').length;
	var url_field_height_3 = url_field_count_3*32

	var file_field_count_3 = $('.column_3').find('.column_form_input input[type=file]').length;
	var file_field_height_3 = file_field_count_3*40

	var time_field_count_3 = $('.column_3').find('.column_form_input input[type=time]').length;
	var time_field_height_3 = time_field_count_3*32
	
	var date_field_count_3 = $('.column_3').find('.column_form_input input[type=date]').length;
	var date_field_height_3 = date_field_count_3*32

	var colour_field_count_3 = $('.column_3').find('.column_form_input input[type=color]').length;
	var colour_field_height_3 = colour_field_count_3*40
	
	var dd_field_count_3 = $('.column_3').find('.column_form_item_dd-select').length;
	var dd_field_height_3 = dd_field_count_3*80

	var form_button_count_3 = $('.column_3').find('.column_form_button').length;
	var form_button_height_3 = form_button_count_3*32

	var form_textarea_count_3 = $('.column_3').find('textarea').length;
	var form_textarea_height_3 = form_textarea_count_3*300
	
	var form_chart_count_3 = $('.column_3').find('.column_bar_chart').length;
	var form_chart_height_3 = form_chart_count_3*350
		
	var col_3 = 40+ select_height_3 + text_field_height_3 + url_field_height_3 + file_field_height_3 + time_field_height_3 + date_field_height_3 + colour_field_height_3 + dd_field_height_3 + form_button_height_3 + form_textarea_height_3 + form_chart_height_3
		


//Set size and location of elements depending on screen size	

	column_width(s_tab, mob, limit);//set column width depending on size of window
	column_width(s_tab, mob, limit);//set column width depending on size of window
	columns_height(s_tab, mob, limit, col_1, col_2, col_3);//set column height depending on size of window	

	$(window).resize(function(){
		column_width(s_tab, mob, limit);//set column width depending on size of window
		columns_height(s_tab, mob, limit, col_1, col_2, col_3);//set column height depending on size of window	

	});




	$(".column_help_tooltip").qtip({ // Grab some elements to apply the tooltip to
	
	    show: 'click',
	    hide: 'unfocus',
	    content: {
	        text: function(event, api) {
	                
	            $.ajax({
	                url: 'http://www.myhq.org.uk/helps/'+$(this).attr('id'),
	                type: 'GET', // POST or GET
	                dataType: 'html',
	            })
	            .then(function(content) {
	                // Now we set the content manually (required!)
	                api.set('content.text', content);
	            }, function(xhr, status, error) {
	                // Upon failure... set the tooltip content to the status and error value
	                api.set('content.text', status + ': ' + error);
	            });
	            return 'Loading...';
	       }
	    },
	        position: {
	        my: 'top right',  // Position my top left...
	        at: 'bottom center', // at the bottom right of...
	    }
	})


});