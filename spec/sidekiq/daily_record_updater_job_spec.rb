# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe DailyRecordUpdaterJob, type: :job do
  include ActiveJob::TestHelper

  let(:male_count) { 5 }
  let(:female_count) { 3 }

  before do
    allow($redis).to receive(:get).with('male').and_return(male_count.to_s)
    allow($redis).to receive(:get).with('female').and_return(female_count.to_s)
  end

  it 'creates or updates a daily record with male and female counts' do
    expect do
      DailyRecordUpdaterJob.new.perform
    end.to change { DailyRecord.count }.by(1)

    record = DailyRecord.last
    expect(record.date).to eq(Date.today)
    expect(record.male_count).to eq(male_count)
    expect(record.female_count).to eq(female_count)
  end

  it 'logs an error if there is a Redis connection issue' do
    allow($redis).to receive(:get).and_raise(Redis::BaseConnectionError.new('Connection error'))

    expect(Sidekiq.logger).to receive(:error).with(/Redis connection error: Connection error/)
    DailyRecordUpdaterJob.new.perform
  end

  it 'logs an error if there is an ActiveRecord validation issue' do
    allow_any_instance_of(DailyRecord).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(DailyRecord.new))

    expect(Sidekiq.logger).to receive(:error).with(/ActiveRecord validation error/)
    DailyRecordUpdaterJob.new.perform
  end

  it 'logs an error for unexpected issues' do
    allow($redis).to receive(:get).and_raise(StandardError.new('Unexpected error'))

    expect(Sidekiq.logger).to receive(:error).with(/Unexpected error: Unexpected error/)
    DailyRecordUpdaterJob.new.perform
  end
end
