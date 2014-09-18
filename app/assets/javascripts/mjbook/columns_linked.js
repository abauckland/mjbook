function columns_linked_width(s_tab, mob, limit) {

  var window_width = $(window).width();

  if(window_width <= limit) {
  	var column_width = window_width-70;
  	$('.sub_column_linked_1, .sub_column_linked_2, .sub_column_linked_3').css({'width': column_width+'px'});
  	$('.sub_column_linked_1, .sub_column_linked_2, .sub_column_linked_3').css({'border':'none'});
  }  
  else if(window_width <= mob && window_width > limit) {
  	var column_width = (window_width/2)-38;  	
  	$('.sub_column_linked_1, .sub_column_linked_2').css({'width':column_width+'px'});
  	$('.sub_column_linked_3').css({'width': column_width+'px'});
  	$('.sub_column_linked_1, .sub_column_linked_3').css({'border-right':'2px solid #dddddd'});
  	$('.sub_column_linked_2').css({'border':'none'}); 	
  }                                                                                                                                  
  else {
  	var column_width = (window_width/3)-32;  	
  	$('.sub_column_linked_1, .sub_column_linked_2, .sub_column_linked_3').css({'width':column_width+'px'});
  	$('.sub_column_linked_1, .sub_column_linked_2').css({'border-right':'2px solid #dddddd'});
  	$('.sub_column_linked_3').css({'border':'none'}); 
  }
};


function columns_linked_height(s_tab, mob, limit, col_1, col_2, col_3) {

	var sub_column_location = 0;
	var window_width = $(window).width();

	if(window_width <= limit) {
  		//reset
		$('.sub_column_linked_1').height((col_1)+'px');
		$('.sub_column_linked_2').height((col_2)+'px');
		$('.sub_column_linked_3').height((col_3)+'px');  	
  		//('.column_content').outerHeight(true);  		
		var highestCol = col_1+col_2+col_3;				
	}else if(window_width <= mob && window_width > limit) {
  		//reset				
		$('.sub_column_linked_3').height((col_3)+'px'); 
		//set height	
		var highestCol = Math.max(col_1, col_2);
		$('.sub_column_linked_1, .sub_column_linked_2').height(highestCol+'px');
	}else{
  		var highestCol = Math.max(col_1, col_2, col_3);
  		$('.sub_column_linked_1, .sub_column_linked_2, .sub_column_linked_3').height(highestCol+'px');
	}
			
	if ($('.column_error').length){	
		var sub_column_location = $('.column_error').outerHeight(true) + 10;						
	}	
	var footer_location = highestCol + sub_column_location+ 10;
	var total_height_container = footer_location + 25;
				
	//set positions of content, line and footer
	$('.sub_column_linked_1').css('top', sub_column_location+'px');	
	$('.column_linked_line').css('top', footer_location+'px');
	$('.column_linked_footer').css('top', footer_location+'px');
	//set total height of bounding box
	$('.column_linked_container').height(total_height_container+'px');													
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
	
	var col_1 = $('.sub_column_linked_1').outerHeight(true);
	var col_2 = $('.sub_column_linked_2').outerHeight(true);
	var col_3 = $('.sub_column_linked_3').outerHeight(true);
	
	//Set size and location of elements depending on screen size	
		columns_linked_width(s_tab, mob, limit);
	columns_linked_height(s_tab, mob, limit, col_1, col_2, col_3);	
	input_width();
	$(window).resize(function(){
		columns_linked_width(s_tab, mob, limit);
		columns_linked_height(s_tab, mob, limit, col_1, col_2, col_3);//set column height depending on size of window
	input_width();
	});

});