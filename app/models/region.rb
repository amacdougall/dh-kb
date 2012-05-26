class Region < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :characters, :through => :cities
  has_many :cities
end
