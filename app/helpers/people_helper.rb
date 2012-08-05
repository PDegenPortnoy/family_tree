module PeopleHelper
  
  def build_links(person)
    links = ""
    links += "Create Parent"
    links += " | Get Married" unless person.married?
    links += " | Have Child"
  end
  
  def rotate_text(text)
    content_tag :div, class: 'narrow_box' do
      content_tag :div, text, class: 'rotated_text'
    end
  end
end
