require 'rails_helper'

RSpec.describe PhrasesController do

  describe 'user tries to access index page' do
    context 'when not logged in ' do
      it 'redirect to log in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end


  describe 'GET index' do
    it 'renders the :index page' do
      user = create(:user)
      sign_in user

      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET show/:id' do
    it 'renders the :show page' do
      user = create(:user)
      phrase = create(:phrase, user: user)
      sign_in user

      get :show, params: { id: phrase.id }
      expect(response).to render_template :show
    end
  end


  describe 'POST create' do

    before do
      user = create(:user)
      sign_in user
    end

    context 'when the phrase is valid ' do
      it 'creates a phrase and redirects to :index page' do

        post :create, params: { phrase:  attributes_for(:phrase)  }

        expect(flash[:notice]).not_to be_empty
        expect(response).to  redirect_to root_path
      end
    end

    context 'when the phrase is invalid' do
      it 're-renders the :new page' do

        post :create, params: { phrase: attributes_for(:phrase, :invalid) }

        expect(flash[:danger]).not_to be_empty
        expect(response).to  render_template :new
      end
    end
  end

  describe 'PUT update/:id' do

    let (:user) { create(:user) }
    let (:phrase) { create(:phrase, user: user) }

    context 'when the user is the author ' do
      it 'updates the phrase and redirects to user :show' do
        sign_in user

        put :update, params: { id: phrase.id, phrase: attributes_for(:phrase, :update) }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'when the user is not an author' do
      it 'redirects to root_path' do
        not_author = create(:user)
        sign_in not_author

        put :update, params: { id: phrase.id, phrase: attributes_for(:phrase, :update) }

        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the phrase is invalid' do
      it 're-renders the user :edit page' do
        sign_in user

        put :update, params: { id: phrase.id, phrase: attributes_for(:phrase, :invalid) }

        expect(flash[:danger]).not_to be_empty
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE destroy/:id' do

    let (:user) { create(:user) }
    let (:phrase) { create(:phrase, user: user) }

    context 'when the user is the author' do
      it 'deletes the phrase and redirects to user :show' do
        sign_in user

        delete :destroy, params: { id: phrase.id }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'when the user is not an author' do
      it 'doesn\'t delete the phrase and redirects to root_path' do
        not_author = create(:user)
        sign_in not_author

        delete :destroy, params: { id: phrase.id }

        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to(root_path)
      end
    end

  end


  # testing voting functionality
  describe '#shared_vote' do
    let (:author) { FactoryBot.create(:user) }
    let (:phrase) { FactoryBot.create(:phrase, user: author) }
    let (:voter) { FactoryBot.create(:user) }

    context 'user upvotes a phrase' do

      before { controller.shared_vote(phrase, 'up', voter) }

      it 'ups score of a phrase' do
        expect(phrase.weighted_score).to eq 1
      end
      it 'ups voter carma' do
        expect(voter.carma).to eq 1
      end
      it 'increments author carma by 4' do
        expect(author.carma).to eq 4
      end
    end

    context 'user unvotes a phrase' do

      before do
        controller.shared_vote(phrase, 'up', voter)
        controller.shared_vote(phrase, 'up', voter)
      end

      it 'decrements phrase scroe' do
        expect(phrase.weighted_score).to eq 0
      end
      it 'decrements voter carma' do
        expect(voter.carma).to eq 0
      end
      it 'decrements voter carma' do
        expect(author.carma).to eq 0
      end
    end

    context 'changes vote on phrase' do

      before do
        controller.shared_vote(phrase, 'up', voter)
        controller.shared_vote(phrase, 'down', voter)
      end

      it 'changes phrase score' do
        expect(phrase.weighted_score).to eq -1
      end
      it 'changes voter\' carma' do
        expect(voter.carma).to eq 1
      end
      it 'changes author\'s carma' do
        expect(author.carma).to eq -2
      end
    end
  end
end
