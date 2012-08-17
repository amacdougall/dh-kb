require 'entity_behavior'

class City < ActiveRecord::Base
  include EntityBehavior

  attr_accessible :description, :name, :region_id

  belongs_to :region
  has_many :characters

  def self.grouped_by_region
    # TODO: revise to use a join or a scope or something
    regions = Region.order "name"
    cities = City.order "name"
    cities_by_region = []

    regions.each do |region|
      cities_for_region = cities.select {|city| city.region_id == region.id}
      unless cities_for_region.empty?
        cities_by_region << {name: region.name, cities: cities_for_region}
      end
    end

    cities_by_region << {
      name: "Uncategorized",
      cities: cities.select {|city| city.region_id.nil?}
    }

    cities_by_region
  end
end
