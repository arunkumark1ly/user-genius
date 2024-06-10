# frozen_string_literal: true

class DailyRecordsController < ApplicationController
  def index
    @daily_records = DailyRecord.all.order(:date)
  end

  def update_records
    DailyRecordUpdaterJob.perform_async
    redirect_to daily_records_path, notice: 'Daily record update job has been enqueued.'
  end
end
