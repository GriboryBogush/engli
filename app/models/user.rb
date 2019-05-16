# frozen_string_literal: true

# User model is used with Devise to add authentication
# has voter functionality and friendly id
class User < ApplicationRecord
  include PublicActivity::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Check for correct email and username on login
  devise :database_authenticatable, authentication_keys: %i[email username]

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :age, presence: true,
                  numericality: { only_integer: true, greater_than: 14, less_than: 100 }
  validates :pro, inclusion: { in: [true, false] }

  # full_name is optional
  validates :full_name, length: { maximum: 30 }, allow_blank: true
  has_many :phrases
  has_many :examples

  # Make user url pretty
  extend FriendlyId
  friendly_id :username, use: :slugged

  # Adds voter functionality
  acts_as_voter

  # Check if there are any notifications for this instance of user
  def new_notifications?
    PublicActivity::Activity.where(recipient_id: id, read: false).any?
  end
end
