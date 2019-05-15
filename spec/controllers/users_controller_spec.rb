require 'rails_helper'

RSpec.describe UsersController do
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
      sign_in user

      get :show, params: { id: user.id }
      expect(response).to render_template :show
    end
  end
end
