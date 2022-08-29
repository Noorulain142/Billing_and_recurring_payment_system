# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.integer :monthly_fee, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
