class DailyRecordsController < ApplicationController
  def index
    @daily_records = DailyRecord.all.order(:date)
  end
end
