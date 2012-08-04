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
  
  describe "get married" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @b = FactoryGirl.create(:person, name: "B")
    end

    it "should get married" do
      @a.marry(@b).should be_true
    end

    it "should be married" do
      @a.marry @b
      @a.married?.should be_true
      @b.married?.should be_true
    end

    it "should return the partner" do
      @a.marry @b
      @a.spouse.should == @b
      @b.spouse.should == @a
    end
  end
  
  describe "has a child when married" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @b = FactoryGirl.create(:person, name: "B")
      @a.marry @b
    end
    
    it "should create a child" do
      @a.has_child("C")
      Person.where(name: "C").first.should_not be_nil
    end
    
    it "should have the child" do
      @c = @a.has_child("C")
      @a.children.first.should == Person.where(name: "C").first
      @a.children.first.should == @c
    end
    
    it "should create the child for the other parent too" do
      @a.has_child("C")
      @b.children.first.should == Person.where(name: "C").first
    end
  end
  
  describe "has multiple children" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @b = FactoryGirl.create(:person, name: "B")
      @a.marry @b
    end
    
    it "should create multiple children for one parent" do
      ["C", "D", "E"].each do |kid|
        @a.has_child(kid)
      end
      @a.children.size.should == 3
    end
    
    it "should have the same number of children for the other parent" do
      ["C", "D", "E"].each do |kid|
        @a.has_child(kid)
      end
      @b.children.size.should == 3
    end
    
    it "should have the same number of children for both parents" do
      @a.has_child("C")
      @a.has_child("D")
      @b.has_child("E")
      @b.has_child("E")
      @a.children.size.should == 4
      @b.children.size.should == 4
    end
  end

  describe "has a child when single" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
    end
    
    it "should create a child" do
      @a.has_child("C")
      Person.where(name: "C").first.should_not be_nil
    end
    
    it "should have the child" do
      @c = @a.has_child("C")
      @a.children.first.should == @c
    end
    
  end
  
  describe "has parents when a child" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @b = FactoryGirl.create(:person, name: "B")
      @a.marry @b
      @a.has_child("C")
      @c = @a.children.first
    end
    
    it "should have two parents" do
      @c.parents.size.should == 2
    end
    
    it "should have the correct parents" do
      @c.parents.map(&:name).should include("A")
      @c.parents.map(&:name).should include("B")
    end
  end
  
  describe "has siblings" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @c = @a.has_child("C")
      @d = @a.has_child("D")
      @e = @a.has_child("E")
    end
    
    it "should have 2 siblings for C" do
      @c.siblings.size.should == 2
      @c.siblings.map(&:name).should include("D")
      @c.siblings.map(&:name).should include("E")
    end

    it "should have 2 siblings for D" do
      @d.siblings.size.should == 2
      @d.siblings.map(&:name).should include("C")
      @d.siblings.map(&:name).should include("E")
    end

    it "should have 2 siblings for E" do
      @e.siblings.size.should == 2
      @e.siblings.map(&:name).should include("D")
      @e.siblings.map(&:name).should include("C")
    end
  end
end
