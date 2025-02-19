class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.string :pet_type
      t.string :tracker_type
      t.integer :owner_id
      t.boolean :in_zone
      t.boolean :lost_tracker

      t.timestamps
    end
  end
end
