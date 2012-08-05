# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Great Grandparents
ggp = Person.create(name: "Great Grandpa", birthdate: 'Feb 01, 1896')
ggm = Person.create(name: "Great Grandma", birthdate: 'Apr 02, 1899')
ggp.marry(ggm)

# Grandma & siblings
gm = ggm.has_child("Grandma", 'Mar 03, 1932')
ggm.has_child("Grand Uncle", 'Jan 04, 1939')
ggm.has_child("Grand Aunt" , 'May 05, 1943')

# Grandpa & Mom's family
gp  = Person.create(name: "Grandpa", birthdate: 'Jul 17, 1927')
gp.marry(gm)
m = gm.has_child("Mother", 'Jun 06, 1955')
gm.has_child("Uncle M", 'Aug 07, 1958')
gm.has_child("Aunt M" , 'Jul 08, 1961')

# Us
f = Person.create(name: "Father", birthdate: 'Sep 09, 1952')
f.marry(m)
s1 = m.has_child("Son 1", 'Aug 10, 1977')
s2 = m.has_child("Son 2", 'Oct 11, 1979')
s3 = m.has_child("Son 3", 'Nov 12, 1981')

# Son 1's family.  Daughter In Law has child before marriage
dil = Person.create(name: "Daughter-In-Law", birthdate: 'Dec 13, 1974')
dil.has_child("Step-Grandson", 'Jan 14, 1992')
s1.marry(dil)
dil.has_child("Granddaughter", 'Feb 15, 1996')

# Son 2's adopted child
s2.has_child("Adopted Granddaughter", 'Mar 16, 1999')
