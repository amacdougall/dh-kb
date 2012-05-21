class Region < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :characters
  has_many :cities
end
