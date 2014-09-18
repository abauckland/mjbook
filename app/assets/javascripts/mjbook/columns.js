//function for setting column width depending on size of window	
function column_width(s_tab, mob, limit) {

var window_width = $(window).width();

  if(window_width <= limit) {
  	var column_width = window_width-44;
  	$('.column_1, .column_2, .column_3, .column_1_2').width(column_width+'px');
  	$('.column_1, .column_2').css({'margin-right':"0px"}); 
  }  
  else if(window_width <= mob && window_width > limit) {  	
  	var column_width = ((window_width-15)/2)-34;
  	var column_3_width = window_width-44;  
	
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


function columns_height(s_tab, mob, limit, col_1, col_2, col_3, col_1_footer) {

	var sub_column_location = 0;
	var window_width = $(window).width();

	if(window_width <= limit) {
  		var footer_location = col_1-col_1_footer;
  		//reset
		$('.column_1').height((col_1)+'px');
		$('.column_1').children('.column_content').children('.column_footer').css('top', footer_location+'px');

	//	$('.column_2').height((col_2)+'px');
	//	$('.column_3').height((col_3)+'px');  	
  		//('.column_content').outerHeight(true);  		
					
	}else if(window_width <= mob && window_width > limit) {
  		//reset				
		$('.column_3').height((col_3)+'px'); 
		//set height	
		var highestCol = Math.max(col_1, col_2);
		$('.column_1, .column_2').height(highestCol+'px');
	}else{
  		var highestCol = Math.max(col_1, col_2, col_3);
  		$('.column_1, .column_2, .column_3').height(highestCol+'px');
	}
			
	//if ($('.column_error').length){	
	//	var sub_column_location = $('.column_error').outerHeight(true) + 10;						
	//}	
	//var footer_location = highestCol + sub_column_location+ 10;
	//var total_height_container = footer_location + 25;
				
	//set positions of content, line and footer	
	//$('.column_line').css('top', footer_location+'px');
	//$('.column_footer').css('top', footer_location+'px');
												
};


function input_width() {
	var w = $('.column_form_item').width();
	$('.column_form_input').css({'width': (w-125) + 'px'});
	$('.column_form_input input[type=text]').css({'width': (w-125) + 'px'});
	$('.column_form_input select').css({'width': (w-125 + 4) + 'px'});
	$('.column_form_input textarea').css({'width': (w-125 - 2) + 'px'});
};

$(document).ready(function(){

	//variables for setting column widths - where 3 coloumns
	var s_tab = '1280';
	var mob = '960';
	var limit = '640';

//$large_menu: 1050px;
//$medium_menu: 800px;
//$small_menu: 400px;

	if ($('.column_1').find('.column_error').length){
		var col_1c = $('.column_1').find('.column_error').outerHeight(true);
	}else{
		var col_1c = 0;	
	}
	var col_1_footer = $('.column_1').find('.column_linked_footer').outerHeight(true);
	var col_1b = $('.column_1').find('.column_form').outerHeight(true);	
	var col_1 = col_1b;
			
	var col_2a = $('.column_2').find('.column_linked_footer').outerHeight(true);
	var col_2b = $('.column_2').find('.column_form').outerHeight(true);
	var col_2c = $('.column_2').find('.column_error').outerHeight(true);
	var col_2 = col_2a + col_2b + col_2c;
	
	var col_3a = $('.column_3').find('.column_linked_footer').outerHeight(true);
	var col_3b = $('.column_3').find('.column_form').outerHeight(true);
	var col_3c = $('.column_3').find('.column_error').outerHeight(true);
	var col_3 = col_3a + col_3b + col_3c;

//Set size and location of elements depending on screen size	

	column_width(s_tab, mob, limit);//set column width depending on size of window
	column_width(s_tab, mob, limit);//set column width depending on size of window
	columns_height(s_tab, mob, limit, col_1, col_2, col_3, col_1_footer);//set column height depending on size of window	
	input_width();
	$(window).resize(function(){
		column_width(s_tab, mob, limit);//set column width depending on size of window
		columns_height(s_tab, mob, limit, col_1, col_2, col_3, col_1_footer);//set column height depending on size of window	
		input_width();
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