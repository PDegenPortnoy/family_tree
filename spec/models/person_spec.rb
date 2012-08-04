require 'spec_helper'

describe Person do
  it "should require a birthdate" do
    no_birthday = FactoryGirl.build(:person, :birthdate => nil)
    lambda {no_birthday.save!}.should raise_error
  end
  it "should require a name" do
    no_name = FactoryGirl.build(:person, :name => nil)
    lambda {no_name.save!}.should raise_error
  end

  
end
