class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :rating
      t.string :message
      t.references :user
      t.timestamps
    end
  end
end
