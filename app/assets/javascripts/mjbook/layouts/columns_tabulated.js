function columns_linked_width(s_tab, mob, limit) {

  var window_width = $(window).width();

  if(window_width <= limit) {
  	var column_width = window_width-44;
  	$('.column_tabulated_1, .column_tabulated_2, .column_tabulated_3').css({'width': column_width+'px'});
  }  
  else if(window_width <= mob && window_width > limit) {
  	var column_width = (window_width/2)-38;  	
  	$('.column_tabulated_1, .column_tabulated_2').css({'width':column_width+'px'});
  	$('.column_tabulated_3').css({'width': column_width+'px'}); 	
  }                                                                                                                                  
  else {
  	var column_width = (window_width/3)-32;  	
  	$('.column_tabulated_1, .column_tabulated_2, .column_tabulated_3').css({'width':column_width+'px'});
  }
};


function column_tab_show(s_tab, mob, limit){
  var window_width = $(window).width();
  
  if(window_width <= limit) {
	$('.column_tabs').show();
	$('li.tab_1').css({'visibility':'visible'});
	$('li.tab_2').css({'visibility':'visible'});
	$('li.tab_3').css({'visibility':'visible'});
	$('.column_tabulated_1').css({'float':'none', 'position':'absolute', 'left': '0px'});
	$('.column_tabulated_2').css({'float':'none', 'position':'absolute', 'left': '0px'}).hide();
	$('.column_tabulated_3').css({'float':'none', 'position':'absolute', 'left': '0px'}).hide();

  }  
  else if(window_width <= mob && window_width > limit) {
	$('.column_tabs').show();
	$('li.tab_1').css({'visibility':'visible'});
	$('li.tab_2').css({'visibility':'visible'});
	$('li.tab_3').css({'visibility':'hidden'});
	
	$('.column_tabulated_2').css({'float':'left'});
	$('.column_tabulated_2').css({'float':'left'});
	$('.column_tabulated_3').css({'float':'none', 'position':'absolute', 'left': '0px'});
  }                                                                                                                                  
  else {
	$('.column_tabs').hide();
	
	$('.column_tabulated_2').css({'float':'left'});
	$('.column_tabulated_3').css({'float':'left'});
  }	
	
};


$(document).ready(function(){


	//variables for setting column widths - where 3 coloumns
	var s_tab = '1280';
	var mob = '960';
	var limit = '640';
	
	//$large_menu: 1050px;
	//$medium_menu: 800px;
	//$small_menu: 400px;
	
	column_tab_show(s_tab, mob, limit);
	$(window).resize(function(){
		column_tab_show(s_tab, mob, limit);
	});



  $('ul.column_tabs').each(function(){
    // For each set of tabs, we want to keep track of
    // which tab is active and it's associated content
    var $active, $content, $links = $(this).find('a');

    // If the location.hash matches one of the links, use that as the active tab.
    // If no match is found, use the first link as the initial active tab.
    $active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
    $active.addClass('active');

    $content = $($active[0].hash);

    // Hide the remaining content
    $links.not($active).each(function () {
      $(this.hash).hide();
    });

    // Bind the click event handler
    $(this).on('click', 'a', function(e){
      // Make the old tab inactive.
      $active.removeClass('active');
      $content.hide();

      // Update the variables with the new link and content
      $active = $(this);
      $content = $(this.hash);

      // Make the tab active.
      $active.addClass('active');
      $content.show();

      // Prevent the anchor's default click action
      e.preventDefault();
    });
  });


	
});