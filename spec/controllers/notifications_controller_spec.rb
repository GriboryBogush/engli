require 'rails_helper'

RSpec.describe NotificationsController do

  describe 'GET index' do
    it 'renders the :index page' do
      user = create(:user)
      sign_in user

      get :index
      expect(response).to render_template :index
    end
  end

  describe 'PUT read_all' do
    it 'sets all user notifications status to \'read\'' do
      user = create(:user)
      sign_in user

      put :read_all
      expect(response.status).to eq 200
    end
  end
end
