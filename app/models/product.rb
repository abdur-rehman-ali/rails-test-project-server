class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :type, type: String
  field :length, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :weight, type: Integer

  validates :name, :type, :length, :width, :height, :weight, presence: true
  validates :length, :width, :height, :weight, numericality: { greater_than_or_equal_to: 0 }
end
