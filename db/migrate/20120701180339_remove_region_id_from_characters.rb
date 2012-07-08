class RemoveRegionIdFromCharacters < ActiveRecord::Migration
  def up
    change_table :characters do |t|
      t.remove :region_id
    end
  end

  def down
    change_table :characters do |t|
      t.integer :region_id
    end
  end
end
