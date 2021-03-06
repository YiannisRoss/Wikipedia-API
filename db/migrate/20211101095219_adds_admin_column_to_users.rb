# frozen_string_literal: true

class AddsAdminColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
