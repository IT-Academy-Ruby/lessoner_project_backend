require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:author) { create(:user) }
  let(:category) { create(:category) }
  let(:lesson) { create(:lesson, author:, category:) }

  context 'valid Factory' do
    it 'has a valid factory' do
      expect(build(:lesson, author:, category:)).to be_valid
    end
  end
end
