class AddCountToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :usage_count, :integer
  end
end
