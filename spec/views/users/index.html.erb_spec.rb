# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index.html.erb', type: :view do
  before do
    users = double('paginated_users')
    allow(users).to receive(:total_pages).and_return(1)
    allow(users).to receive(:current_page).and_return(1)
    allow(users).to receive(:limit_value).and_return(2)  # assuming per page limit is 2 for simplicity

    allow(users).to receive(:each).and_yield(User.new(id: 1, name: { 'last' => 'Kandasamy', 'first' => 'ArunKumar', 'title' => 'Mr' }, age: 30, gender: "Male", created_at: '2023-01-02'))
                                    .and_yield(User.new(id: 2, name: { 'last' => 'ArunKumar', 'first' => 'Megala', 'title' => 'Mrs' }, age: 25, gender: "Female", created_at: '2023-01-03'))

    assign(:users, users)
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

    expect(rendered).to include('<td>Mr ArunKumar Kandasamy</td>')
    expect(rendered).to include('<td>30</td>')
    expect(rendered).to include('<td>Male</td>')
    expect(rendered).to include('<td>2023-01-02</td>')

    expect(rendered).to include('<td>Mrs Megala ArunKumar</td>')
    expect(rendered).to include('<td>25</td>')
    expect(rendered).to include('<td>Female</td>')
    expect(rendered).to include('<td>2023-01-03</td>')
  end

  it 'includes delete links for each user' do
    expect(rendered.scan(/data-turbo-method="delete"/).count).to eq(2)
  end
end
