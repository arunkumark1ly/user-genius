require 'rails_helper'

RSpec.describe "daily_records/index.html.erb", type: :view do
  before do
    assign(:daily_records, [
      DailyRecord.create!(date: Date.today, male_count: 50, female_count: 50, male_avg_age: 50.0, female_avg_age: 50.0),
      DailyRecord.create!(date: Date.yesterday, male_count: 50, female_count: 50, male_avg_age: 50.0, female_avg_age: 50.0)
    ])
    render
  end

  it "displays a table with daily records" do
    expect(rendered).to include('<th>Date</th>')
    expect(rendered).to include('<th>Male Count</th>')
    expect(rendered).to include('<th>Female Count</th>')
    expect(rendered).to include('<th>Male Avg Age</th>')
    expect(rendered).to include('<th>Female Avg Age</th>')

    expect(rendered).to include("<td>#{Date.today.strftime('%Y-%m-%d')}</td>")
    expect(rendered).to include('<td>50</td>')
    expect(rendered).to include('<td>50</td>')
    expect(rendered).to include('<td>50</td>')
    expect(rendered).to include('<td>50</td>')

    expect(rendered).to include("<td>#{Date.yesterday.strftime('%Y-%m-%d')}</td>")
    expect(rendered).to include('<td>50</td>')
    expect(rendered).to include('<td>50</td>')
    expect(rendered).to include('<td>50</td>')
    expect(rendered).to include('<td>50</td>')
  end
end
