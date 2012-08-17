class EntitiesController < ApplicationController
  def completions
    # TODO: cache completions?
    [Character, City, Region, Group].inject([]) do |result, type|
      result += type.all.map do |e|
        {id: e.id, name: e.name, type: type.name.downcase.pluralize}
      end
    end
  end
end
