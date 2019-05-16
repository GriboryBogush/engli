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
    author = FactoryBot.build(:user)
    not_author = FactoryBot.build(:user)
    phrase = FactoryBot.build(:phrase, user: author)

    it 'returns true if author is the same' do
      expect(phrase.author?(author)).to eq true
    end

    it 'returns true if author is different' do
      expect(phrase.author?(not_author)).to eq false
    end
  end

  describe 'carma is properly calculated' do
    it 'is should equal zero' do
      author = FactoryBot.build(:user)
      phrase = FactoryBot.build(:phrase, user: author)
      voter  = FactoryBot.build(:user)

      phrase.set_carma('up', voter)
      phrase.redo_carma('down', voter)
      phrase.unset_carma('down', voter)

      expect(voter.carma).to eq 0
      expect(author.carma).to eq 0
    end
  end
end
