# frozen_string_literal: true

# Module for common methods between Phrase and Example models
module SharedMethods
  include ActiveSupport::Concern

  def author?(user)
    self.user == user
  end
end
