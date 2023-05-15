import jquery from "jquery"
window.$ = jquery

$(document).on('turbolinks:load', function(){
  if(localStorage.timerUrl != location.href) {
    $('.form-question').show()}
  else {
    $('.form-question').hide();
  };

  $('.question_show').on('click', '.edit-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('.form-question').show();
  });

  $('.question_show').on('click', '.save-question', function() {
    localStorage.timerUrl = location.href
    $('.form-question').hide();
    $('.edit-question-link').show();
  });
});
