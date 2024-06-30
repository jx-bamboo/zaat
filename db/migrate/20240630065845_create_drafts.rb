class CreateDrafts < ActiveRecord::Migration[7.1]
  def change
    create_table :drafts do |t|
      t.string :prompt
      t.text :image
      t.text :model
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
