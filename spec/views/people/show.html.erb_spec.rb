require 'spec_helper'

describe "people/show" do
  describe "One Person, no family" do
    before(:each) do
      @a = assign(:person, FactoryGirl.create(:person))
      assign(:spouse, @a.spouse)
      assign(:parents, @a.parents)
      assign(:siblings, @a.siblings)
      assign(:children, @a.children)
    end

    it "renders _person partial to display the person" do
      render
      view.should render_template(partial: 'people/_person', count: 1)
    end
  end
  
  describe "One Parent, One child" do
    before(:each) do
      @a = assign(:person, FactoryGirl.create(:person))
      @a.has_child("b")
      assign(:spouse, @a.spouse)
      assign(:parents, @a.parents)
      assign(:siblings, @a.siblings)
      assign(:children, @a.children)
    end
    
    it "should do something" do
      render
      view.should render_template(partial: 'people/_person', count: 2)
    end
  end
  
end
