class CharacterCityRegionReferences < ActiveRecord::Migration
  def up
    change_table :characters do |t|
      t.integer :city_id
      t.integer :region_id
    end

    change_table :cities do |t|
      t.integer :region_id
    end
  end

  def down
    change_table :cities do |t|
      t.remove :region_id
    end

    change_table :characters do |t|
      t.remove :city_id
      t.remove :region_id
    end
  end
end
