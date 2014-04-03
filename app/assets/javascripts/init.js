$('document').ready(function(){
	$('#menu').Menu();
    $('.data_view').dataTable();
    var today = new Date();
    $('.datepicker').multiDatesPicker();
});