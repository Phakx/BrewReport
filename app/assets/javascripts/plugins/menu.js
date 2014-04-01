(function ( $, window, document, undefined ) {


    var pluginName = "Menu",
        defaults = {
        };

    function Menu( element, options ) {
        this.menu = $(element);

        this.options = $.extend( {}, defaults, options) ;

        this._defaults = defaults;
        this._name = pluginName;

        this.init();
    }

    Menu.prototype = {

        init: function() {
           this.addEventListeners();
        },

        addEventListeners: function(el, options) {
            this.menu.on('click', 'a', $.proxy(this.onMenuClick,this));
        },

        onMenuClick: function(event){
            this.menu.find('.active').removeClass('active');
            var clickedMenuItem = $(event.currentTarget).parent().addClass('active');
        }

    };


    $.fn[pluginName] = function ( options ) {
        return this.each(function () {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName,
                new Menu( this, options ));
            }
        });
    };

})( jQuery, window, document );
