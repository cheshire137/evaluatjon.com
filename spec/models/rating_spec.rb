require 'rails_helper'

RSpec.describe Rating, type: :model do
  it 'requires a dimension' do
    expect(subject).to have(1).error_on(:dimension)
  end

  it 'requires stars' do
    expect(subject).to have(2).errors_on(:stars)
  end

  it 'requires stars >= 0' do
    subject.stars = -0.5
    expect(subject.save).to eq(false)
    expect(subject).to have(1).error_on(:stars)
  end

  it 'requires stars <= 10' do
    subject.stars = 10.5
    expect(subject.save).to eq(false)
    expect(subject).to have(1).error_on(:stars)
  end

  it 'requires a rater' do
    expect(subject).to have(1).error_on(:rater)
  end

  describe 'to_json' do
    subject { build(:rating).to_json }

    it 'does not include user_id' do
      expect(subject).to_not include('user_id')
    end

    it 'does not include user' do
      expect(subject).to_not include('user')
    end
  end
end
