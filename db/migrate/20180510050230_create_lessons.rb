class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
    	t.string :name, unique: true, index: true
    	t.integer :progression_order, index: true, unique: true

      t.timestamps
    end
  end
end
