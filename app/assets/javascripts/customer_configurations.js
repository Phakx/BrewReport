// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
    var altFieldDates = $('#altField').val();
    var dates = altFieldDates === '' ? altFieldDates : altFieldDates.split(',');

    $('#datepicker').multiDatesPicker({
        dateFormat: "dd/mm/yy",
        addDates: dates,
        altField: '#altField'
    });

});