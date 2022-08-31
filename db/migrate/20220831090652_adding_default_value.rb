class AddingDefaultValue < ActiveRecord::Migration[5.2]
  def change
    change_column :plans, :monthly_fee, :integer, null: false, default: 0
    change_column :features, :usage_value, :integer, null: false, default: 0
    change_column :features, :max_unit_limit, :integer, null: false, default: 0
    change_column :features, :unit_price, :integer, null: false, default: 0
  end
end
