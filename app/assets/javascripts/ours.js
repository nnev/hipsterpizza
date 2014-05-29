//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require _both
//= require _save_button_handler
//= require _reload_handler
//= require bootstrap/dropdown
//= require bootstrap/collapse
//= require bootstrap/modal

Turbolinks.enableTransitionCache();

$(document).ready(function() {
  'use strict';
  $('.modal').on('shown.bs.modal', function() {
    $(this).find('input:visible:first').focus();
  });
});
