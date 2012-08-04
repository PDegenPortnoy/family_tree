class Relationship < ActiveRecord::Base
  attr_accessible :person_id, :target, :type
  validates_presence_of :target
  belongs_to :person
end

