require 'rails_helper'

RSpec.describe User, type: :model do
  it 'requires an email' do
    expect(subject).to have(1).error_on(:email)
  end

  it 'requires a password' do
    expect(subject).to have(1).error_on(:password)
  end

  it 'requires a password with >8 characters' do
    subject.password = 'wd40'
    expect(subject).to have(1).error_on(:password)
  end

  it 'allows a password with 8 characters' do
    subject.password = 'wd40rocks'
    expect(subject).to have(0).errors_on(:password)
  end

  it 'requires a password with <128 characters' do
    subject.password = 'a' * 129
    expect(subject).to have(1).error_on(:password)
  end

  context 'when a user exists' do
    let(:user) { create(:user) }

    it 'requires a unique email' do
      subject.email = user.email
      expect(subject).to have(1).error_on(:email)
    end

    it 'requires a password confirmation to change password' do
      user.password = 'new password'
      expect(user).to have(1).error_on(:password_confirmation)
    end
  end
end
