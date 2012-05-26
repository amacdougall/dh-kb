class AssociateCharactersAndGroups < ActiveRecord::Migration
  def up
    create_table :characters_groups, :id => false do |t|
      t.integer :character_id
      t.integer :group_id
    end
  end

  def down
    drop_table :characters_groups
  end
end
