require 'spec_helper'

describe Relationship do
  it "should require a target" do
    r = FactoryGirl.build(:relationship, person_id: 1, target: nil)
    lambda{r.save!}.should raise_error
  end
  
end
