class City < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :region
  has_many :characters
end
