class Person < ActiveRecord::Base
  attr_accessible :birthdate, :name
  validates_presence_of :birthdate
  validates_presence_of :name
end
