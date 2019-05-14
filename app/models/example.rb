class Example < ApplicationRecord
  #includes author?, set_carma, redo_carma, unset_carma methods
  include SharedMethods

  # ??? Used for making notifications on controller actions
  include PublicActivity::Model

  belongs_to :user
  belongs_to :phrase

  validates :example, presence: true, uniqueness: { scope: :phrase_id }

  # Add voting functionality
  acts_as_votable
end
