# frozen_string_literal: true

# Example reprsenets an example of a phrase being used
# Has votable functionality
class Example < ApplicationRecord
  # includes author?, set_carma, redo_carma, unset_carma methods
  include SharedMethods

  # Used for making notifications on :vote
  include PublicActivity::Common

  belongs_to :user
  belongs_to :phrase

  validates :example, presence: true, uniqueness: { scope: :phrase_id }

  # Add voting functionality
  acts_as_votable
end
