#  Saving Star: Family Tree Exercise
Peter Degen-Portnoy

August 5, 2012


## To Install
    > git clone git://github.com/PeterDP/family_tree.git
    > cd family_tree
    > bundle install
    > rake db:setup

## To Verify Installation
    > rake spec

## To Run 
    > rails s

Running at default location: localhost:3000

## Notes 
 * Tested in Chrome 20.0.1132.57 and Firefox 13.0.1 in OS/X 
 * A family has to start somewhere.  Siblings are defined by having the same parent (at least one),
   so, at the top of the family tree, which are the root node grandparents, those grandparents
   can't have any siblings
 * To create a new person, use the "New Person" link at the bottom of the "People in the Family" index page.  Most everything else can be
   done from the person show page.
 * Marriage is between two people, no checking is performed.  Polygamy is not allowed.
 * Divorce is not implemented, but would be supported.  People can end their marriage, marry to another, 
   and produce offspring
 * I chose to hide the edit person functionality at this point.
 
## Known Issues
 * Through the "parent" link, you can create more than two parents, though that's not possible when
   Person A marries Person B and has a child
 * The click event for the class "create_person" was occasionally not being registered.  The behavior was intermittent and resulted
   in the Create Person, Create Parent and Create Child modal dialog not being used and the default HTML page to be displayed instead.  
   Haven't seen that in a while, though.