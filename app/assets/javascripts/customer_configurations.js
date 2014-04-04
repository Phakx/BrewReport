// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
    if ($("#customer_configuration").length > 0) {

        var $checkboxes = $("#checkbox_container").find('input[type=checkbox]');
        $checkboxes.on('change', function () {
            var ids = $checkboxes.filter(':checked').map(function () {
                return this.value;
            }).get().join(',');
            $('#weekly_input').val(ids);
        });
        var preselect = $('#weekly_input').val().split(",");
        $.each(preselect, function (index, value) {
            $('#checkbox_container').find(':input[value=' + value + ']').prop('checked', true)
        });

        var altFieldDates = $('#altField').val();
        var dates = altFieldDates === '' ? altFieldDates : altFieldDates.split(',');

        $('#datepicker').multiDatesPicker({
            dateFormat: "dd/mm/yy",
            addDates: dates,
            altField: '#altField'
        });
    }
});