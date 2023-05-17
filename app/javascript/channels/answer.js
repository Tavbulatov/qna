import jquery from "jquery"
window.$ = jquery

$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});