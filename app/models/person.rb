class Person < ActiveRecord::Base
  attr_accessible :birthdate, :name
  validates_presence_of :birthdate
  validates_presence_of :name
  has_one :partner
  
  def marry(b)
    create_partner(target: b.id)
    b.create_partner(target: self.id)
  end
  
  def married?
    !partner.nil?
  end
  
  def spouse
    return nil unless married?
    Person.find(partner.target)
  end
end
