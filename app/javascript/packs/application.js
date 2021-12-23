// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require_tree .
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require('jquery')
Rails.start()
// Turbolinks.start()
ActiveStorage.start()
$(function(){
  setTimeout("$('.notice').fadeOut('slow')", 2000);
});
import "chartkick/chart.js"