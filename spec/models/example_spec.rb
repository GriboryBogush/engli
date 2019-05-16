# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Example do
  describe 'validations' do
    let(:phrase) { create(:phrase) }
    let(:first_example) { create(:example, phrase: phrase) }

    subject do
      build(:example, example: first_example.example, phrase: phrase)
    end
    it { is_expected.to validate_presence_of(:example) }
    it { is_expected.to validate_uniqueness_of(:example).scoped_to(:phrase_id) }
  end

  describe '#author?' do
    let(:author) { create(:user) }
    let(:not_author) { build(:user) }
    let(:example) { build(:example, user: author) }

    context 'author is the same' do
      it 'returns true' do
        expect(example.author?(author)).to be true
      end
    end
    context 'author is different' do
      it 'returns true ' do
        expect(example.author?(not_author)).to be false
      end
    end
  end
end
