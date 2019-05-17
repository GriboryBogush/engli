# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do

  describe 'GET index' do
    it_behaves_like 'has index action'
  end

  describe 'GET show/:id' do
    it_behaves_like 'has show action', :user
  end
end
