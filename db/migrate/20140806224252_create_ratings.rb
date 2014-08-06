class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :dimension, null: false
      t.string :comment
      t.string :rater
      t.float :stars, null: false
      t.timestamps
    end
  end
end
