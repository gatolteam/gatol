require 'rails_helper'

RSpec.describe Student, type: :model do
  before { @user = FactoryGirl.build(:student) }

  subject { @user }

  it { is_expected.to respond_to(:email) }

  it { is_expected.to respond_to(:password) }

  it { is_expected.to respond_to(:password_confirmation) }

  it { is_expected.to respond_to(:auth_token) }

  describe "#generate_authentication_token!" do
  	it "generate an unique token" do
      allow(Devise).to receive(:friendly_token).and_return("token1")
  	  @user.generate_authentication_token!
  	  expect(@user.auth_token).to eql "token1"
  	end

  	it "generate another token when it is already taken" do
  	  existing_user = FactoryGirl.create(:trainer, auth_token: "token1")
  	  @user.generate_authentication_token!
  	  expect(@user.auth_token).not_to eql existing_user.auth_token
  	end
  end

  it { is_expected.to be_valid }


  # pending "add some examples to (or delete) #{__FILE__}"
end
