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
    length, width, height, weight = params.values_at(:length, :width, :height, :weight).map(&:to_i)
    result = BestMatchService.new(length, width, height, weight).call
    if result.key?(:error)
      render json: result, status: :not_found
    else
      render json: result
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
