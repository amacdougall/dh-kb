require "data_mapper"

class Character
  include DataMapper::Resource

  EXPOSED = [:city, :region, :groups]

  property :id, Serial
  property :name, String, :required => true
  property :description, Text
  belongs_to :city, :required => false
  belongs_to :region, :required => false
  has n, :groups, :through => Resource
end

class City
  include DataMapper::Resource

  EXPOSED = [:region, :characters]

  property :id, Serial
  property :name, String, :required => true
  property :description, Text
  belongs_to :region, :required => false
  has n, :characters
end

class Region
  include DataMapper::Resource

  EXPOSED = [:characters, :cities]

  property :id, Serial
  property :name, String, :required => true
  property :description, Text
  has n, :characters
  has n, :cities
end

class Group
  include DataMapper::Resource

  EXPOSED = [:characters]

  property :id, Serial
  property :name, String, :required => true
  property :description, Text
  has n, :characters, :through => Resource
end
