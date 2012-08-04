class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :person_id
      t.integer :target
      t.string :type

      t.timestamps
    end
  end
end
