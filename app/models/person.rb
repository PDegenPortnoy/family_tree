class Person < ActiveRecord::Base
  attr_accessible :birthdate, :name
  validates_presence_of :birthdate
  validates_presence_of :name
  has_one :partner
  has_many :offspring
  
  default_scope order('birthdate asc')
  
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
  
  def has_child(name, birthdate)
    person = Person.create(name: name, birthdate: birthdate)
    associate_child(person)
  end
  
  def associate_child(person)
    offspring.create(target: person.id)
    spouse.offspring.create(target: person.id) if married?
    person
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
    associate_parent(parent)
  end
  
  def associate_parent(parent)
    Offspring.create(person_id: parent.id, target: self.id)
    parent
  end
  
  def create_relationship(relationship, params)
    person = Person.create(params['person'])
    case relationship
    when 'parent'
        associate_parent(person)
    when 'child'
        associate_child(person)
    else
        raise 'invalid relationship: "#{relationship}"'
    end
  end
  
  def self.unmarried
    Person.find_by_sql("select * from people where id not in 
                        (select person_id from relationships where type = 'Partner') 
                        and id not in 
                        (select target from relationships where type = 'Partner')
                        order by birthdate asc")
  end
end
