$(document).ready(function() {
	
	$('input:radio').on('click', function(){
		var method = $(this).val();
		var invoice_id = $(this).parent('span').attr('id');
		$(location).attr('href', "http://localhost:3000/mjbook/processinvoices/"+invoice_id+"/"+method);
	});

	
	$('input:checkbox').on('click', function(){

		var all = $('input:checkbox');
		var all_checked = all.filter(':checked');
		
		var id = 1;
		
		var checked_ids = all_checked.map(function(){
			return this.value;
		}).get();
		
		$.ajax({
			//#{ Rails.root.to_s }
			url: '/mjbook/processinvoices',
			type: 'get',
			dataType: 'json',
			data: 'checked_ids='+checked_ids +'',
			success: function(data){
				
				var p = parseFloat(data.invoice_price).toFixed(2);
				var v = parseFloat(data.invoice_vat_due).toFixed(2);
				var t = parseFloat(data.invoice_total).toFixed(2);
				
				$("div.total_right span p").html('£' + t).css({ 'color': 'blue'});
				
				$(".payment_scope_price").html('£' + p).css({ 'color': 'blue'});
				$(".payment_scope_vat_due").html('£' + v).css({ 'color': 'blue'});
				$(".payment_scope_total").html('£' + t).css({ 'color': 'blue'});
				
				$("input#payment_price").val(data.invoice_price);
				$("input#payment_vat").val(data.invoice_vat_due);
				$("input#payment_total").val(data.invoice_total);
				
				$("input#inline_ids").val(data.inline_ids);
			}
		});
	});

});
