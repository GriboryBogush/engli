# frozen_string_literal: true

# Phrase has functionality of a votable
# PublicActivity is used to add notifications on every 5 upvotes
class Phrase < ApplicationRecord
  # includes author?, set_carma, redo_carma, unset_carma methods
  include SharedMethods

  # ??? Used for making notifications on controller actions
  include PublicActivity::Model

  CATEGORIES = [['Actions', 0], ['Time', 1], ['Productivity', 2],
                ['Apologies', 3], ['Common', 4]].freeze

  belongs_to :user
  has_many :examples
  accepts_nested_attributes_for :examples, allow_destroy: true
  validates :phrase, :translation, presence: true
  validates :phrase, uniqueness: true
  validates :category, inclusion: {
    in: %w[Actions Time Productivity Apologies Common],
    message: '%{value} is not a valid categoty'
  }

  enum category: %w[Actions Time Productivity Apologies Common]

  # Make phrase url pretty
  extend FriendlyId
  friendly_id :phrase, use: :slugged

  # Add voting functionality
  acts_as_votable
end
