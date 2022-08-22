class AddColoumnsToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :product_id, :string
    add_column :plans, :price_id, :string
  end
end
