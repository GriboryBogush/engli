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
    it { should validate_uniqueness_of(:example).scoped_to(:phrase_id) }
  end

  describe "#author?" do
    let(:author) { build(:user) }
    let(:not_author) { build(:user) }
    let(:example) { build(:example, user: author) }

    it "returns true if author is the same" do
      expect(example.author?(author)).to be_true
    end

    it "returns true if author is different" do
      expect(example.author?(not_author)).to be_false
    end
  end
end
