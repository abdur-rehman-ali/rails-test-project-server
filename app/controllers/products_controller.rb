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
    max_length = params[:length].to_i
    max_width = params[:width].to_i
    max_height = params[:height].to_i
    max_weight = params[:weight].to_i
  
    products = Product.where(:length.eq => max_length, :width.eq => max_width, :height.eq => max_height, :weight.eq => max_weight).first
    
    if products
      render json: products
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
