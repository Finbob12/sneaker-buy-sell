class AddDefaultValueToListings < ActiveRecord::Migration[6.0]
  def change
    change_column_default :listings, :sold, false
  end
end
