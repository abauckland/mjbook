$(document).ready(function(){

	$('input#invoice_content_blank').click(function (){		
		$('select#invoice_invoicetype_id').removeAttr('disabled');
		$('select#invoice_invoiceterm_id').removeAttr('disabled');
	  	$('select#clone_invoice').attr('disabled', 'disabled');
	  	$('select#clone_quote').attr('disabled', 'disabled');
	  	$('select#invoice_project_id').removeAttr('disabled');		  
	});
	
	$('input#invoice_content_clone_invoice').click(function (){		
		$('select#clone_invoice').removeAttr('disabled');
		$('select#clone_quote').attr('disabled', 'disabled');
	  	$('select#invoice_invoicetype_id').attr('disabled', 'disabled');
	  	$('select#invoice_invoiceterm_id').attr('disabled', 'disabled');
	  	$('select#invoice_project_id').removeAttr('disabled');	
	});

	$('input#invoice_content_clone_quote').click(function (){		
		$('select#clone_quote').removeAttr('disabled');
		$('select#clone_invoice').attr('disabled', 'disabled');
	  	$('select#invoice_invoicetype_id').removeAttr('disabled');
	  	$('select#invoice_invoiceterm_id').removeAttr('disabled');
	  	$('select#invoice_project_id').attr('disabled', 'disabled');	
	});


});