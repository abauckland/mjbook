$(document).ready(function(){

	$('input#invoice_content_blank').click(function (){
		
		$('select#invoice_invoicetype_id').removeAttr('disabled');
		$('select#invoice_invoiceterm_id').removeAttr('disabled');
	  	$('select#clone_invoice').attr('disabled', 'disabled');
	    
	});
	
	$('input#invoice_content_clone').click(function (){
		
		$('select#clone_invoice').removeAttr('disabled');
	  	$('select#invoice_invoicetype_id').attr('disabled', 'disabled');
	  	$('select#invoice_invoiceterm_id').attr('disabled', 'disabled');
	
	});

});