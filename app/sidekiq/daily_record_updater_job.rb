class DailyRecordUpdaterJob
  include Sidekiq::Job

  def perform
    begin
      male_count = $redis.get("male").to_i
      female_count = $redis.get("female").to_i

      daily_record = DailyRecord.find_or_initialize_by(date: Date.today)
      daily_record.male_count = male_count
      daily_record.female_count = female_count
      
      daily_record.save!
    rescue Redis::BaseConnectionError => e
      # Handle Redis connection errors
      Sidekiq.logger.error "Redis connection error: #{e.message}"
    rescue ActiveRecord::RecordInvalid => e
      # Handle errors related to ActiveRecord validations
      Sidekiq.logger.error "ActiveRecord validation error: #{e.message}"
    rescue StandardError => e
      # Handle any other types of unexpected errors
      Sidekiq.logger.error "Unexpected error: #{e.message}"
    end
  end
end
