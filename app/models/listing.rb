class Listing < ApplicationRecord
    belongs_to :user
    has_one_attached :picture
    validates_presence_of :brand, :style, :price, :size, :picture, :description
    validates :brand, format: { with: /^[a-zA-Z0-9]*$/, :multiline => true, message: "should only contain basic letters and numbers" }
    validates :price, numericality: { only_integer: true }
    validates :size, numericality: { only_integer: true }
    validates :style, length: { maximum: 200, too_long: "can't be that stylish! Please use 200 characters or less"}
    validates :description, length: { maximum: 500, too_long: "can't be that descriptive! Please use 500 characters or less"}
end