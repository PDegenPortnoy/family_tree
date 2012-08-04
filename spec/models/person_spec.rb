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
  
  it "should successfully add a person" do
    p = FactoryGirl.create(:person)
    p.should be_valid
    Person.where(name: FactoryGirl.attributes_for(:person)[:name]).first.should eq(p)
  end
  
  describe "marriage" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @b = FactoryGirl.create(:person, name: "B")
    end

    it "should get married" do
      @a.marry(@b).should be_true
    end

    it "should be married" do
      @a.marry(@b)
      @a.married?.should be_true
      @b.married?.should be_true
    end

    it "should return the partner" do
      @a.marry(@b)
      @a.spouse.should == @b
      @b.spouse.should == @a
    end
  end
end
