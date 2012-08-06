module PeopleHelper
  
  def build_links(person)
    links = ""
    links += link_to "Create Parent", new_person_path(relationship: 'parent', origin: person), class: 'create_person'
    unless person.married?
      links += " | Get Married" 
    end
    links += " | "
    links += link_to "Have Child", new_person_path(relationship: 'child', origin: person), class: 'create_person'
    raw(links)
  end
  
  def rotate_text(text)
    content_tag :div, class: 'narrow_box' do
      content_tag :div, text, class: 'rotated_text'
    end
  end
end
