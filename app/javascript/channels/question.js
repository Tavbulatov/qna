import jquery from "jquery"
window.$ = jquery

$(document).on('turbolinks:load', function(){

  if($('.question_show').length) {
    $('.form-question').hide();}
  else {
    $('.form-question').show()
  }

  $('.question_show').on('click', '.edit-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('.form-question').show();
  });

  $('.question_show').on('click', '.save-question', function() {
    $('.form-question').hide();
    $('.edit-question-link').show();
  });
});
