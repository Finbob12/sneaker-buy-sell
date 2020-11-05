class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.string :brand
      t.string :style
      t.integer :size
      t.text :description
      t.boolean :sold

      t.timestamps
    end
  end
end
