$(document).ready(function(){

	$('select#expense_hmrcexpcat_id').change(function (){

		if($('select#expense_hmrcexpcat_id option:selected').text() == 'business mileage'){

			$('select#expense_mileage_attributes_mileagemode_id').removeAttr('disabled');
			$('input#expense_mileage_attributes_start').removeAttr('disabled');
			$('input#expense_mileage_attributes_finish').removeAttr('disabled');
			$('input#expense_mileage_attributes_distance').removeAttr('disabled');

			$('select#expense_supplier_id').attr('disabled', 'disabled');
			$('input#expense_ref').attr('disabled', 'disabled');
			$('input#expense_receipt').attr('disabled', 'disabled');
			$('input#expense_price').attr('disabled', 'disabled');
			$('input#expense_vat').attr('disabled', 'disabled');
			$('input#expense_total').attr('disabled', 'disabled');

		} else {

			$('select#expense_mileage_attributes_mileagemode_id').attr('disabled', 'disabled');
			$('input#expense_mileage_attributes_start').attr('disabled', 'disabled');
			$('input#expense_mileage_attributes_finish').attr('disabled', 'disabled');
			$('input#expense_mileage_attributes_distance').attr('disabled', 'disabled');

			$('select#expense_supplier_id').removeAttr('disabled');
			$('input#expense_ref').removeAttr('disabled');
			$('input#expense_receipt').removeAttr('disabled');
			$('input#expense_price').removeAttr('disabled');
			$('input#expense_vat').removeAttr('disabled');
			$('input#expense_total').removeAttr('disabled');

		}
	});

});