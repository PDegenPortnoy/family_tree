require 'spec_helper'

describe "people/show" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    # TO DO: Fix assigns so this renders correctly
    # render
    # rendered.should match(/Name/)
  end
end
