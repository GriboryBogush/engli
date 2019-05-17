# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET index' do
    it_behaves_like 'has index action'
  end

  describe 'PUT read_all' do
    it 'sets all user notifications status to \'read\'' do
      put :read_all
      expect(response.status).to eq 200
    end
  end
end
