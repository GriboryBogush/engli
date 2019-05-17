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
    it_behaves_like 'has author', :phrase
  end
end
