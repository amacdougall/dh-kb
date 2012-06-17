require 'andand'

class Character < ActiveRecord::Base
  attr_accessible :description, :name, :city_id, :region_id, :group_ids

  belongs_to :city
  belongs_to :region
  has_and_belongs_to_many :groups

  # Returns character's city's region, or character's region, or nil. Note that
  # if the character has both a city and a region, the region of the city will
  # override the explicit region. This is a matter of convenience, so that a
  # character's region can be inferred from the chosen city.
  def region
    city.andand.region || super || nil
  end
end
