# frozen_string_literal: true

class DailyRecord < ApplicationRecord
  # Include the Dirty module to track changes
  include ActiveModel::Dirty

  # Define callbacks to update average ages before saving if counts change
  before_save :update_average_ages, if: :counts_changed?

  private

  # Check if male_count or female_count has changed
  def counts_changed?
    male_count_changed? || female_count_changed?
  end

  # Update male_avg_age and female_avg_age based on current data in User table
  def update_average_ages
    self.male_avg_age = User.where(gender: 'male').average(:age).to_f if male_count_changed?

    return unless female_count_changed?

    self.female_avg_age = User.where(gender: 'female').average(:age).to_f
  end
end
