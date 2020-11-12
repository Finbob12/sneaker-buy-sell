class ChangeColumnNullOnListings < ActiveRecord::Migration[6.0]
  def change
    change_column_null :listings, :brand, false
    change_column_null :listings, :style, false
    change_column_null :listings, :size, false
    change_column_null :listings, :description, false
    change_column_null :listings, :price, false
  end
end
