

//hide existing jeditable for span
$('table#<%= @line.id %>').find('.quote_line_item').hide().after("<td class='qline_new_item'>Test</td>");

// update item  
    $('.qline_new_item').mouseover(function(){
    var line_id = $(this).attr('id');
        $(this).editable('http://localhost:3000/mjbook/qlines/'+line_id+'/new_item', {
            id: line_id, width: ($(this).width() +10)+'px',
            type: 'text',
            ajaxoptions: {dataType: 'script'},
            onblur: 'submit',
            method: 'PUT',
            indicator: 'Saving..',
            submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
        }); 
    });
    
$('table#<%= @line.id %>').find('.qline_new_item').focus();
//bind new jeditable input and focus on span to initiate jeditable
//$('table#<%= @old_line_id %>').find('cat span').unbind()
//