require 'rails_helper'

RSpec.describe User, type: :model do
  before { create :user, email: }
  let(:email) { 'arson@mail.com' }

  context 'valid Factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  shared_examples 'Checks that user invalid' do
    it 'is invalid' do
      expect(user.valid?).to eq(false)
    end
  end

  context 'when email is duplicated' do
    let(:email) { 'arson@mail.com' }
    let(:user) { build :user, email: }

    include_examples 'Checks that user invalid'
  end

  context 'when birthday is blank' do
    let(:user) { build :user, birthday: nil }

    include_examples 'Checks that user invalid'
  end

  context 'when birthdate is invalid' do
    let(:user) { build :user, birthday: '01.01.20' }

    include_examples 'Checks that user invalid'
  end

  context 'when gender is blank' do
    let(:user) { build :user, gender: nil }

    include_examples 'Checks that user invalid'
  end
end
