class Offspring < Relationship
  belongs_to :person
  
  # non-obvious name to avoid confusion between multiple uses of the word "parent"
  scope :producers, lambda{ |id| where(target: id)}

  # non-obvious name to avoid confusion between multiple uses of the word "siblings"
  # returns an array of People IDs that represent the siblings of the target ID submitted
  def self.peer_ids(target)
    # TODO return nil if target != integer
    producer_ids = Offspring.producers(target).map(&:person_id)
    # find Offspring with the same producers (e.g. parents), don't include target, map the remaining targets and filter out duplicates
    Offspring.where(person_id: producer_ids).reject{|o| o.target == target}.map(&:target).uniq
  end
end
