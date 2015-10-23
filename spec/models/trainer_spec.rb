require 'rails_helper'

RSpec.describe Trainer, type: :model do
  before { @user = FactoryGirl.build(:trainer) }

  subject { @user }

  it { should respond_to(:email) }

  it { should respond_to(:password) }

  it { should respond_to(:password_confirmation) }

  it { should be_valid }



  # pending "add some examples to (or delete) #{__FILE__}"
end
