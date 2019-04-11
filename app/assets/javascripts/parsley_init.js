// Inititalize Parsley JS for front end form validation.
$(document).on('turbolinks:load', function() {
  var form = $('form');
  if (form.length) {
    var parsley_form = form.parsley();
  }
  $(document).on('turbolinks:before-cache', function() {
    if (parsley_form) {
      if (Array.isArray(parsley_form)) {
        $.each(parsley_form, function(index, form) {
          form.destroy()
        });
      }
      else {
        parsley_form.destroy();
      }
      parsley_form = null;
    }
  });
});
