class City < ActiveRecord::Base
  attr_accessible :description, :name, :region_id

  belongs_to :region
  has_many :characters
end
