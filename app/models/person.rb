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
    p
  end

  def children
    Person.where(id: offspring.map(&:target)) #return [] if no children
  end
  
  def parents
    Person.where(id: Offspring.producers(self.id).map(&:person_id)) # return [] if no parents
  end
  
  def siblings
    Person.where(id: Offspring.peer_ids(self.id)) # return [] if no siblings
  end
  
  def create_parent(name, birthdate)
    parent = Person.create(name: name, birthdate: birthdate)
    Offspring.create(person_id: parent.id, target: self.id)
    parent
  end
end
