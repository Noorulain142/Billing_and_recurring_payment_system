# frozen_string_literal: true

class RenameTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :buyer_plans, :subscriptions
  end
end
