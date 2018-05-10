class CreateLessonParts < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_parts do |t|
    	t.references :lesson

    	t.integer :progression_order, index: true

    	t.string :name

      t.timestamps
    end
  end
end
