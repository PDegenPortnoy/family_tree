module PeopleHelper
  
  def build_links(person)
    links = ""
    links += link_to "Parent", new_person_path(relationship: 'parent', origin: person), class: 'create_person'
    unless person.married?
      links += " | " 
      links += link_to "Marry", select_spouse_person_path(person)
    end
    links += " | "
    links += link_to "Child", new_person_path(relationship: 'child', origin: person), class: 'create_person'
    raw(links)
  end
  
  def rotate_text(text)
    content_tag :div, class: 'narrow_box' do
      content_tag :div, text, class: 'rotated_text'
    end
  end
  
  def available_people_options(available)
    available.map{|elem| [elem.name, elem.id]}
  end
end
