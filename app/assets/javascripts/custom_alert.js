(function() {
  var handleConfirm = function(element) {
    if (!allowAction(this)) {
      Rails.stopEverything(element)
    }
  }

  var allowAction = function(element) {
    if (element.getAttribute('data-confirm-swal') === null) {
      return true
    }
    showConfirmationDialog(element)
    return false
  }

  // Display the confirmation dialog
  var showConfirmationDialog = function(element) {
    var message = element.getAttribute('data-confirm-swal')

    swal({
      title: message,
      type: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes',
      confirmButtonColor: '#0A8564',
      cancelButtonText: 'No',
      cancelButtonColor: '#E02F38',
    }).then(function(result) {
      confirmed(element, result)
    })
  }

  var confirmed = function(element, result) {
    if (result.value) {
      // User clicked confirm button
      element.removeAttribute('data-confirm-swal')
      element.click()
    }
  }

  // Hook the event before the other rails events so it works together
  // with `method: :delete`.
  document.addEventListener('rails:attachBindings', function(e) {
    Rails.delegate(document, 'a[data-confirm-swal]', 'click', handleConfirm)
  })

}).call(this)
