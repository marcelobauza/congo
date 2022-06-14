$(document).on('keyup change', '[data-flex-amount]', function(event) {
  var plans        = $('[data-flex-plans]').data('flexPlans')
  var currentValue = +$('[data-flex-amount]').val()
  var priceByPlans

  $.each(plans, function (i, data) {
    var quantity = data[1]
    var price    = data[0]

    if (currentValue >= quantity) {
      priceByPlans = price

      return false
    }
  })

  $('[data-flex-amount-text]').text(priceByPlans)
})
