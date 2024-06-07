class FetchUsersWorkerJob
  include Sidekiq::Job

  def perform(*args)
    # Fetch data from the API
    response = HTTParty.get('https://randomuser.me/api/?results=20')
    if response.success?
      users_data = response.parsed_response['results']

      # Iterate over each user data and store in the database
      users_data.each do |user_data|
        byebug
      end
    else
      # Log error or handle it as needed
      Rails.logger.error "Failed to fetch users: #{response.body}"
    end
  end
end