require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid full name with prefix' do
    user = User.new('name' => {"last"=>"Kandasamy", "first"=>"ArunKumar", "title"=>"Mr"})
    expect(user.full_name_with_title).to eq("Mr ArunKumar Kandasamy")
  end
end