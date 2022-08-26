# frozen_string_literal: true

class AddOverUseToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :over_use, :integer
  end
end
