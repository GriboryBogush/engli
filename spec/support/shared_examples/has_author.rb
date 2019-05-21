RSpec.shared_examples 'has author' do |object_with_author|
  let(:author) { build(:user) }
  let(:not_author) { build(:user) }
  subject(object_with_author) { build(object_with_author, user: author) }

  context 'author is the same' do
    it 'returns true' do
      expect(subject.author?(author)).to be true
    end
  end
  context 'author is different' do
    it 'returns true' do
      expect(subject.author?(not_author)).to be false
    end
  end
end
