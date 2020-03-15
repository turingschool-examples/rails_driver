function addMerchantUpdateHandler(merchant_id, button, input) {
  button.click(function(event){
    event.preventDefault()
    let name = input.value
    data = {
      id: merchant_id,
      name: name
    }

    let uri = `/api/v1/merchants/${merchant_id}`
    updateResource(uri, data, function(merchant){
      window.location = `/admin/merchants/${merchant.id}`
    })
  })
}

function loadMerchantsWithMostRevenue(container) {
  let uri = '/api/v1/merchants/most_revenue?quantity=10'
  loadMultipleResources(uri, function(merchant){
    merchantElement = merchantListItem(merchant, '/admin/merchants/')
    container.append(merchantElement)
  })
}

function loadMerchantsWithMostItemsSold(container) {
  let uri = '/api/v1/merchants/most_items?quantity=10'
  loadMultipleResources(uri, function(merchant){
    merchantElement = merchantListItem(merchant, '/admin/merchants/')
    container.append(merchantElement)
  })
}

function loadRevenueForPastWeek(container) {
  let start = '03-02-2012'
  let end = '03-08-2012'
  let uri = `/api/v1/revenue?start=${start}&end=${end}`
  loadResource(uri, function(revenue) {
    let revenueElement = `<p>${revenue.attributes.revenue}</p>`
    $("#recent-revenue").append(revenueElement)
  })
}

function addMerchantSearchHandler(button, input, resultsContainer){
  button.click(function(event){
    event.preventDefault()
    let name = input[0].value
    let uri = `/api/v1/merchants/find_all?name=${name}`
    resultsContainer.append('<h3>Search Results</h3>')
    loadMultipleResources(uri, function(merchant){
      element = merchantListItem(merchant, '/admin/merchants/')
      resultsContainer.append(element)
    })
  })
}
