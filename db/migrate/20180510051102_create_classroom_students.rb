class CreateClassroomStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :classroom_students do |t|
    	t.references :classroom
    	t.references :student

      t.timestamps
    end
  end
end
