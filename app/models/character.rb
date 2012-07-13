require 'andand'

class Character < ActiveRecord::Base
  attr_accessible :description, :name, :city_id, :group_ids

  belongs_to :city
  has_and_belongs_to_many :groups

  # Returns the first sentence of the description field. Does its best to
  # handle sentences which end in quotations or parentheses. If it fails
  # to find the end of the first sentence, it displays a 25-word excerpt
  # followed by an ellipsis.
  def short_description
    terminator = description.match /[.?!]['"]? /

    if not terminator.nil?
      description[0..terminator.offset(0).first]
    else
      description.split(" ")[0..25].join(" ") + "..."
    end
  end

  # Returns character's city's region, or character's region, or nil. Note that
  # if the character has both a city and a region, the region of the city will
  # override the explicit region. This is a matter of convenience, so that a
  # character's region can be inferred from the chosen city.
  def region
    city.andand.region || nil
  end
end
