class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true

  before_destroy :enqueue_recalculation

  def full_name_with_title
    "#{name["title"]} #{name["first"]} #{name["last"]}"
  end

  private

  def enqueue_recalculation
    daily_record_date = self.created_at.to_date
    # Convert the date to a string in ISO 8601 format
    RecalculateAverageAgeJob.perform_async(daily_record_date.iso8601, self.gender)
  end
end
