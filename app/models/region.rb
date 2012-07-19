class Region < ActiveRecord::Base
  include EntityBehavior

  attr_accessible :description, :name

  has_many :characters, :through => :cities
  has_many :cities
end
