require 'json'

file = File.read(Rails.root.join('db', 'products.json'))
data = JSON.parse(file)
data["products"].each do |product|
  Product.create!(
    name: product['name'],
    type: product['type'],
    length: product['length'],
    width: product['width']
    height: product['height'],
    weight: product['weight']
  )
end
