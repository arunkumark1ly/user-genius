# frozen_string_literal: true

class FetchUsersJob
  include Sidekiq::Job

  def perform
    response = HTTParty.get('https://randomuser.me/api/?results=20')
    if response.success?
      users_data = response.parsed_response['results']

      users_data.each do |user_data|
        User.transaction do
          user = User.find_or_initialize_by(uuid: user_data['login']['uuid'])
          user.assign_attributes(
            gender: user_data['gender'],
            name: user_data['name'],
            location: user_data['location'],
            age: user_data['dob']['age']
          )
          user.save!
        end
      end
      update_gender_counts_in_redis
    else
      Rails.logger.error "Failed to fetch users: #{response.body}"
    end
  end

  private

  def update_gender_counts_in_redis
    $redis.set('male', count_users_by_gender('male').to_s)
    $redis.set('female', count_users_by_gender('female').to_s)
  end

  def count_users_by_gender(gender)
    User.where(gender:)
        .where('created_at >= ? AND created_at < ?', Date.current.beginning_of_day, Date.current.end_of_day)
        .count
  end
end
