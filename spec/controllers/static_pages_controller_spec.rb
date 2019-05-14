require 'rails_helper'

RSpec.describe StaticPagesController do
  describe 'GET hello' do
    it 'renders the hello page' do
      user = FactoryBot.create(:user)
      sign_in user

      get :hello
      expect(response).to render_template 'static_pages/hello'
    end
  end
end
