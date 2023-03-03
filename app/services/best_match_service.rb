class BestMatchService
  def initialize(length, width, height, weight)
    @length = length.to_i
    @width = width.to_i
    @height = height.to_i
    @weight = weight.to_i
  end

  def call
    products = find_products
    return { error: 'No product found that matches the given dimensions and weight' } if products.empty?

    best_match = find_best_product_match(products)
    best_match.as_json
  end

  private

  attr_reader :length, :width, :height, :weight

  def find_products
    Product.where(:length.gte => length, :width.gte => width, :height.gte => height, :weight.gte => weight)
  end

  def find_best_product_match(products)
    best_match = nil
    length_diff, height_diff, width_diff, weight_diff = Float::INFINITY, Float::INFINITY, Float::INFINITY, Float::INFINITY
  
    products.each do |product|
      package_length_diff, package_width_diff, package_height_diff, package_weight_diff = calculate_package_difference(product)

      next unless package_length_diff <= length_diff && package_width_diff <= width_diff && package_height_diff <= height_diff && package_weight_diff <= weight_diff

      length_diff, width_diff, height_diff, weight_diff = package_length_diff, package_width_diff, package_height_diff, package_weight_diff
      best_match = product
    end

    best_match
  end

  def calculate_package_difference(product)
    package_length_diff = product.length - length
    package_width_diff = product.width - width
    package_height_diff = product.height - height
    package_weight_diff = product.weight - weight

    [package_length_diff, package_width_diff, package_height_diff, package_weight_diff]
  end
end
