class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  # Returns all products
  def index
    @products = Product.all
    render json: @products, status: :ok
  end

  # GET /products/:id
  # Returns a single product by ID
  # Required parameters:
  #   - id: integer (product ID)
  def show
    render json: @product, status: :ok
  end

  # GET /products/find_best_match
  # Returns a single product
  # Required parameters:
  #     - length: integer
  #     - width: integer
  #     - height: integer
  #     - weight: integer
  def find_best_match
    length = params[:length].to_i
    width = params[:width].to_i
    height = params[:height].to_i
    weight = params[:weight].to_i
  
    products = Product.where(:length.gte => length, :width.gte => width, :height.gte => height, :weight.gte => weight)
  
    # If there are no products that match the given dimensions and weight
    if products.empty?
      render json: { error: 'No product found that matches the given dimensions and weight' }, status: :not_found
      return
    end
  
    # Initialize the differences to a very high value
    length_diff = Float::INFINITY
    height_diff = Float::INFINITY
    width_diff = Float::INFINITY
    weight_diff = Float::INFINITY
  
    best_match = nil
  
    # Loop through each product and find the one with the smallest differences
    products.each do |product|
      package_length_diff = product.length - length
      package_width_diff = product.width - width
      package_height_diff = product.height - height
      package_weight_diff = product.weight - weight
  
      if package_length_diff <= length_diff && package_width_diff <= width_diff && package_height_diff <= height_diff && package_weight_diff <= weight_diff
        length_diff = package_length_diff
        width_diff = package_width_diff
        height_diff = package_height_diff
        weight_diff = package_weight_diff
        best_match = product
      end
    end
  
    # If there is a best match, render it
    if best_match
      render json: best_match
    else
      render json: { error: 'No product found that matches the given dimensions and weight' }, status: :not_found
    end
  end
  
  

  
  
  

  # POST /products
  # Creates a new product
  # Required parameters:
  #   - product: hash containing product attributes
  #     - name: string
  #     - type: string
  #     - length: integer
  #     - width: integer
  #     - height: integer
  #     - weight: integer
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PUT /products/:id
  # Updates an existing product by ID
  # Required parameters:
  #   - id: integer (product ID)
  #   - product: hash containing product attributes
  #     - name: string
  #     - type: string
  #     - length: integer
  #     - width: integer
  #     - height: integer
  #     - weight: integer
  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
    
  end

  # DELETE /products/:id
  # Deletes a single product by ID
  # Required parameters:
  #   - id: integer (product ID)
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :type, :length, :width, :height, :weight)
  end
end
