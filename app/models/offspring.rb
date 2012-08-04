class Offspring < Relationship
  belongs_to :person
  scope :producers, lambda{ |id| where(target: id)}

  def self.peer_ids(target)
    producer_ids = Offspring.producers(target).map(&:person_id)
    # find Offspring with the same producers (e.g. parents), don't include target, map the remaining targets and filter out duplicates
    Offspring.where(person_id: producer_ids).reject{|o| o.target == target}.map(&:target).uniq
  end
end
