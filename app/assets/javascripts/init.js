$('document').ready(function () {
    $('#menu').Menu();
    $('.data_view').dataTable({

        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            // Bold the grade for all 'A' grade browsers
            if (aData[1].indexOf("CRITICAL") != -1) {
                $(nRow).removeClass();
                $(nRow).toggleClass("critical");
            }
        }
    });
});

