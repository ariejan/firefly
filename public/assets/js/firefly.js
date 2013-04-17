$(document).ready(function() {

  var input_type = $('#input_type :input');
  var sources    = $('.source');

  sources.filter(':not(#file)').hide();

  input_type.on('change', function() {
    var chosen = '#' + $(this).val();

    sources.filter(chosen).show().find('input').prop('disabled', false);
    sources.not(chosen).hide().val('').find('input').prop('disabled', true);
  });

  var action = $('#actions select'), languages = $('#languages');
  action.on("change", function(e) {
    languages.toggle(action.val() == "ocr");
  });
});
