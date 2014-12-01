// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
jQuery(document).ready(function ($) {		

	$('#field_id').ddslick({
		attribute_id: "field_id",
	    attribute_name: "model[field_id]",
		width: 180,
		//ddslick.js has been altered directly to get correct dropdown sise and content and provide parameters required by rails
	});	


	//attached to any input whose class = "maxlength"
	$('.maxlength').keyup(function () {
	  var max = $(this).attr('maxLength');
	  var len = $(this).val().length;
	  if (len >= max) {
	    $(this).next().text(' you have reached the limit').css('color','red');
	  } else {
	    var char = max - len;
	    $(this).next().text(char + ' characters left').css('color','green');
	  }
	});


});