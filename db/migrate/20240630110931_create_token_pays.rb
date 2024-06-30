class CreateTokenPays < ActiveRecord::Migration[7.1]
  def change
    create_table :token_pays do |t|
      t.string :chain
      t.string :toekn_name
      t.string :contract_address
      t.text :contract_abi
      t.string :receive
      t.decimal :price

      t.timestamps
    end
  end
end
