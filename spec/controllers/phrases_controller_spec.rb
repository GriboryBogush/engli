require 'rails_helper'

RSpec.describe PhrasesController do
  describe 'GET index' do
    it 'renders the index page' do
      user = FactoryBot.create(:user)
      sign_in user

      get :index
      expect(response).to render_template :index
    end
  end

  describe '#shared_vote' do
    let (:author) { FactoryBot.build(:user) }
    let (:phrase) { FactoryBot.build(:phrase, user: author) }
    let (:voter) { FactoryBot.build(:user) }

    it 'upvotes a phrase' do

      controller.shared_vote(phrase, 'up', voter)

      expect(phrase.weighted_score).to eq 1
      expect(voter.carma).to eq 1
      expect(author.carma).to eq 4
    end

    it 'unvotes a phrase' do
      controller.shared_vote(phrase, 'up', voter)
      controller.shared_vote(phrase, 'up', voter)

      expect(phrase.weighted_score).to eq 0
      expect(voter.carma).to eq 0
      expect(author.carma).to eq 0
    end

    it 'changes vote on phrase' do
      controller.shared_vote(phrase, 'up', voter)
      controller.shared_vote(phrase, 'down', voter)

      expect(phrase.weighted_score).to eq -1
      expect(voter.carma).to eq 1
      expect(author.carma).to eq -2
    end
  end
end
