require 'rails_helper'

RSpec.describe Reply, type: :model do
  it 'requires a rating' do
    expect(subject).to have(1).error_on(:rating)
  end

  it 'requires a user' do
    expect(subject).to have(1).error_on(:user)
  end

  it 'requires a message' do
    expect(subject).to have(1).error_on(:message)
  end

  describe 'to_json' do
    subject { build(:reply).to_json }

    it 'does not include user_id' do
      expect(subject).to_not include('user_id')
    end

    it 'does not include user' do
      expect(subject).to_not include('user')
    end
  end
end
