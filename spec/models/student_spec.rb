require 'rails_helper'

RSpec.describe Student, type: :model do
  before { @user = FactoryGirl.build(:student) }

  subject { @user }

  it { should respond_to(:email) }

  it { should respond_to(:password) }

  it { should respond_to(:password_confirmation) }

  it { should respond_to(:auth_token) }

  describe "#generate_authentication_token!" do
  	it "generate an unique token" do
  	  Devise.stub(:friendly_token).and_return("token1")
  	  @user.generate_authentication_token!
  	  expect(@user.auth_token).to eql "token1"
  	end

  	it "generate another token when it is already taken" do
  	  existing_user = FactoryGirl.create(:trainer, auth_token: "token1")
  	  @user.generate_authentication_token!
  	  expect(@user.auth_token).not_to eql existing_user.auth_token
  	end
  end

  it { should be_valid }


  # pending "add some examples to (or delete) #{__FILE__}"
end
