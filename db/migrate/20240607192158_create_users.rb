# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def up
    create_table :users do |t|
      t.string :uuid, null: false, index: { unique: true }
      t.string :gender
      t.jsonb :name
      t.jsonb :location
      t.integer :age, null: false, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
