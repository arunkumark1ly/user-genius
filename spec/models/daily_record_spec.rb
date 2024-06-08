require 'rails_helper'

RSpec.describe DailyRecord, type: :model do
  describe 'callbacks' do
    let(:daily_record) { DailyRecord.new(male_count: 10, female_count: 20) }

    shared_examples 'updates average age based on gender count' do |gender, initial_count, updated_count, age, expected_avg_age|
      it "updates the #{gender}_avg_age" do
        create_list(:user, initial_count, gender: gender, age: age)
        daily_record.send("#{gender}_count=", updated_count)
        daily_record.save!
        expect(daily_record.send("#{gender}_avg_age")).to eq(expected_avg_age)
      end
    end

    context 'when male_count changes' do
      include_examples 'updates average age based on gender count', 'male', 5, 15, 30, 30.0
    end

    context 'when female_count changes' do
      include_examples 'updates average age based on gender count', 'female', 5, 25, 25, 25.0
    end
  end
end
