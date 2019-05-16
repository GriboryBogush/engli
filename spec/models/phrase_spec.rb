# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phrase do
  describe 'validations' do
    subject { create(:phrase) }
    it { is_expected.to validate_presence_of(:phrase) }
    it { is_expected.to validate_uniqueness_of(:phrase) }
    it { is_expected.to validate_presence_of(:translation) }
    # it { is_expected.to validate_inclusion_of(:category)
    #   .in_array(%w(Actions Time Productivity Apologies Common))
    #   .with_message('%{value} is not a valid categoty') }
  end

  describe '#author?' do
    let(:author) { build(:user) }
    let(:not_author) { build(:user) }
    let(:phrase) { build(:phrase, user: author) }

    context 'author is the same' do
      it 'returns true' do
        expect(phrase.author?(author)).to be true
      end
    end
    context 'author is different' do
      it 'returns true' do
        expect(phrase.author?(not_author)).to be false
      end
    end
  end
end
