# frozen_string_literal: true

module SharedMethods
  include ActiveSupport::Concern

  # Check if a given user is author of phrase/example
  def author?(user)
    self.user == user
  end
end
