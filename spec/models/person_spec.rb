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
    Person.where(name: FactoryGirl.attributes_for(:person)[:name]).last.should eq(p)
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
      @a.has_child("C", Date.today())
      Person.where(name: "C").first.should_not be_nil
    end
    
    it "should have the child" do
      @c = @a.has_child("C", Date.today())
      @a.children.first.should == Person.where(name: "C").first
      @a.children.first.should == @c
    end
    
    it "should create the child for the other parent too" do
      @a.has_child("C", Date.today())
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
        @a.has_child(kid, Date.today())
      end
      @a.children.size.should == 3
    end
    
    it "should have the same number of children for the other parent" do
      ["C", "D", "E"].each do |kid|
        @a.has_child(kid, Date.today())
      end
      @b.children.size.should == 3
    end
    
    it "should have the same number of children for both parents" do
      @a.has_child("C", Date.today())
      @a.has_child("D", Date.today())
      @b.has_child("E", Date.today())
      @b.has_child("E", Date.today())
      @a.children.size.should == 4
      @b.children.size.should == 4
    end
  end

  describe "has a child when single" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
    end
    
    it "should create a child" do
      @a.has_child("C", Date.today())
      Person.where(name: "C").first.should_not be_nil
    end
    
    it "should have the child" do
      @c = @a.has_child("C", Date.today())
      @a.children.first.should == @c
    end
    
  end
  
  describe "has parents when a child" do
    before(:each) do
      @a = FactoryGirl.create(:person, name: "A")
      @b = FactoryGirl.create(:person, name: "B")
      @a.marry @b
      @a.has_child("C", Date.today())
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
      @c = @a.has_child("C", Date.today())
      @d = @a.has_child("D", Date.today())
      @e = @a.has_child("E", Date.today())
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
  
  describe "creating parents" do
    before(:each) do
      @a = FactoryGirl.create(:person)
    end
  
    it "should not have parents initially" do
      @a.parents.size.should == 0
    end
    
    it "should create a parent for the person" do
      b = @a.create_parent("B", 'Jan 01, 1950')
      b.should be_valid
    end
  end
  
  describe "associating people" do
    before(:each) do
      @a = FactoryGirl.create(:person)
      @b = {"authenticity_token"=>"u5RzQ19lMGqvT8iNc8hHjEieJA1pHBI97GFM2df1yGI=", "relationship"=>"parent", 
            "person"=>{"name"=>"B", "birthdate(1i)"=>"2012", "birthdate(2i)"=>"8", "birthdate(3i)"=>"6"}, "commit"=>"Create Person"}
    end
    
    it "should create a person B and associate it to A as the parent" do
      @a.create_relationship('parent', @b)
      @a.parents.size.should == 1
      @a.parents[0].name.should == "B"
    end
    
    it "should create person B and associate it to A as a child" do
      @a.create_relationship('child', @b)
      @a.children.size.should == 1
      @a.children[0].name.should == "B"
    end
  end  
end
