class Person < ActiveRecord::Base
  attr_accessible :birthdate, :name
  validates_presence_of :birthdate
  validates_presence_of :name
  has_one :partner
  has_many :offspring
  
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
  
  def has_child(name, birthdate = Date.today())
    p = Person.create(name: name, birthdate: birthdate)
    offspring.create(target: p.id)
    spouse.offspring.create(target: p.id) if married?
  end

  def children
    return nil if offspring.empty?
    Person.find(offspring.map(&:target))
  end
  
end
