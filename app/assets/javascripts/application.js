// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require lib/jquery.min
//= require lib/jquery.ui.core
//= require lib/jquery.ui.datepicker
//= require lib/prettify
//= require lib/lang-css
//= require jquery.turbolinks
//= require init
//= require plugins/jquery.dataTables.min.js
//= require plugins/menu
//= require plugins/jquery-ui.multidatespicker
//= require customer_configurations
//= require turbolinks

//Multidate Picker fix (relies on old jquery behaviour which is no longer available)
jQuery.browser = {};
(function () {
    jQuery.browser.msie = false;
    jQuery.browser.version = 0;
    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
        jQuery.browser.msie = true;
        jQuery.browser.version = RegExp.$1;
    }
})();