# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExamplesController do
  let(:user) { create(:user) }

  describe 'POST show/:id/create' do
    let(:phrase) { create(:phrase, user: user) }
    before { sign_in user }

    context 'when the example is valid' do
      it 'creates an example and redirects to phrase :show path' do
        params = { params: { phrase_id: phrase.id, example: attributes_for(:example) } }
        # weird stuff, but it works
        params[:params][:example][:user_id] = user.id

        post :create, params

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase)
      end
    end

    context 'when the example is invalid' do
      it 'doesn\t create and example and redirects to phrase :show path' do
        post :create, params: { phrase_id: phrase.id, example: attributes_for(:example, :invalid) }

        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase)
      end
    end
  end

  describe 'DELETE destroy/:id' do
    let(:phrase) { create(:phrase, user: user) }
    let(:example) { create(:example, phrase: phrase, user: user) }

    context 'when user is the user of the example' do
      it 'deletes an example and redirects to phrase :show path' do
        sign_in user

        delete :destroy, params: { phrase_id: phrase.id, id: example.id }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase)
      end
    end

    context 'when user is the user of the phrase' do
      it 'deletes an example and redirects to phrase :show path' do
        another_user = create(:user)
        another_example = create(:example, phrase: phrase, user: another_user)
        sign_in user

        delete :destroy, params: { phrase_id: phrase.id, id: another_example.id }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase)
      end
    end

    context 'when user is not an user of example/phrase' do
      it 'does not delete an example and redirects to root_path' do
        another_user = create(:user)
        sign_in another_user

        delete :destroy, params: { phrase_id: phrase.id, id: example.id }

        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to root_path
      end
    end
  end

  # testing voting functionality
  describe '#shared_vote' do
    let(:example) { create(:example, user: user) }
    let(:voter) { create(:user) }

    context 'when user upvotes an example' do
      before { controller.shared_vote('up', example, voter) }

      it 'ups score of an example' do
        expect(example.weighted_score).to eq 1
      end
      it 'ups voter carma' do
        expect(voter.carma).to eq 1
      end
      it 'increments user carma by 4' do
        expect(user.carma).to eq 2
      end
    end

    context 'when user unvotes an example' do
      before do
        controller.shared_vote('up', example, voter)
        controller.shared_vote('up', example, voter)
      end

      it 'decrements example scroe' do
        expect(example.weighted_score).to eq 0
      end
      it 'decrements voter carma' do
        expect(voter.carma).to eq 0
      end
      it 'decrements voter carma' do
        expect(user.carma).to eq 0
      end
    end

    context 'when user changes vote on example' do
      before do
        controller.shared_vote('up', example, voter)
        controller.shared_vote('down', example, voter)
      end

      it 'changes example score' do
        expect(example.weighted_score).to eq(-1)
      end
      it 'changes voter\' carma' do
        expect(voter.carma).to eq 1
      end
      it 'changes user\'s carma' do
        expect(user.carma).to eq(-1)
      end
    end
  end
end
