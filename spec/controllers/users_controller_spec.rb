# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET index' do
    it 'renders the :index page' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET show/:id' do
    it 'renders the :show page' do
      get :show, params: { id: user.id }
      expect(response).to render_template :show
    end
  end
end
