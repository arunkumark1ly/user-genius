# frozen_string_literal: true

class CreateDailyRecords < ActiveRecord::Migration[7.1]
  def up
    create_table :daily_records do |t|
      t.date :date
      t.integer :male_count, default: 0
      t.integer :female_count, default: 0
      t.float :male_avg_age, default: 0.0
      t.float :female_avg_age, default: 0.0

      t.timestamps
    end

    # Add indexes to commonly queried fields for performance improvement
    add_index :daily_records, :date
    add_index :daily_records, :male_count
    add_index :daily_records, :female_count
  end

  def down
    # Remove indexes first before dropping the table
    remove_index :daily_records, :date
    remove_index :daily_records, :male_count
    remove_index :daily_records, :female_count

    drop_table :daily_records
  end
end
