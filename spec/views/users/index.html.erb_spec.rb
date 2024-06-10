# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index.html.erb', type: :view do
  before do
    assign(:users, [
             User.create!(uuid: 123, name: { 'last' => 'Kandasamy', 'first' => 'ArunKumar', 'title' => 'Mr' }, age: 30,
                          gender: 'Male', created_at: Time.zone.now),
             User.create!(uuid: 124, name: { 'last' => 'ArunKumar', 'first' => 'Megala', 'title' => 'Mrs' }, age: 25,
                          gender: 'Female', created_at: Time.zone.now)
           ])
    assign(:total_users, 2)
    render
  end

  it 'displays the total number of users' do
    expect(rendered).to match(/Total Users: 2/)
  end

  it 'renders a search form' do
    expect(rendered).to include('<form')
    expect(rendered).to include('class="d-flex mb-3"')
    expect(rendered).to include('action="/users"')
  end

  it 'displays a table with users' do
    expect(rendered).to include('<table')
    expect(rendered).to include('<th>Name</th>')
    expect(rendered).to include('<th>Age</th>')
    expect(rendered).to include('<th>Gender</th>')
    expect(rendered).to include('<th>Created At</th>')
    expect(rendered).to include('<th>Actions</th>')
    expect(rendered).to include('<td>Mr ArunKumar Kandasamy</td>')
    expect(rendered).to include('<td>30</td>')
    expect(rendered).to include('<td>Male</td>')
    expect(rendered).to include('<td>Mrs Megala ArunKumar</td>')
    expect(rendered).to include('<td>25</td>')
    expect(rendered).to include('<td>Female</td>')
  end

  it 'includes delete links for each user' do
    expect(rendered.scan(/data-turbo-method="delete"/).count).to eq(2)
  end
end
