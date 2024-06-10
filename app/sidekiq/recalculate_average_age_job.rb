# frozen_string_literal: true

class RecalculateAverageAgeJob
  include Sidekiq::Job

  def perform(daily_record_date, gender)
    daily_record_date = Date.iso8601(daily_record_date)
    daily_record = DailyRecord.find_by(date: daily_record_date)
    return unless daily_record

    # Calculate the new average age
    new_average = User.where(gender:, created_at: ..daily_record_date.end_of_day).average(:age).to_f

    # Calculate the new count
    new_count = User.where(gender:, created_at: daily_record_date.all_day).count

    # Update the DailyRecord with new average age and count
    if gender == 'male'
      daily_record.update(male_avg_age: new_average, male_count: new_count)
    else
      daily_record.update(female_avg_age: new_average, female_count: new_count)
    end
  end
end
