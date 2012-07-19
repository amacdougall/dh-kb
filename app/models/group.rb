class Group < ActiveRecord::Base
  include EntityBehavior

  attr_accessible :description, :name, :character_ids

  has_and_belongs_to_many :characters
end
