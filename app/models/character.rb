class Character < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :city
  belongs_to :region
  has_and_belongs_to_many :groups
end
