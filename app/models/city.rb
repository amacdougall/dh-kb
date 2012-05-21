class City < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :characters
  belongs_to :region
end
