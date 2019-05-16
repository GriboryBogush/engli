# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController do
  describe 'GET hello' do
    it 'renders the hello page' do
      user = create(:user)
      sign_in(user)

      get('hello')

      assert_template 'static_pages/hello'
    end
  end
end
