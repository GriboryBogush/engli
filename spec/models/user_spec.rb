require 'rails_helper'

RSpec.describe User, "validations" do
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_numericality_of(:age).only_integer.is_greater_than(14).is_less_than(100) }
#  it { is_expected.to validate_inclusion_of(:pro)
#      .in_array([true, false]) }
  it { is_expected.to validate_length_of(:full_name).is_at_most(30) }
end
