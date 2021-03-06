// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require jquery.balloon

function showDialog() {
    $('.dialog-background').removeClass('hide');
    $('.dialog-container').removeClass('hide');
}

function hideDialog() {
    var $background = $('.dialog-background');
    var $container = $('.dialog-container');
    $background.addClass('opacity0');
    $container.addClass('hide');
    setTimeout(function () {
        $background.removeClass('opacity0');
        $background.addClass('hide');
    }, 300);
}

function setBaloon(elm, option) {
    var baloonOption = {
        position: 'top',
        minLifetime: 0,
        hideDuration: 0,
        css: {
            'box-shadow': 'none',
            'background-color': '#142941',
            border: 'none',
            padding: '7px 10px'
        }
    };
    option = option || baloonOption;
    $(elm).balloon(option);
}