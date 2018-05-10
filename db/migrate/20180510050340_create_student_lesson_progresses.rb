class CreateStudentLessonProgresses < ActiveRecord::Migration[5.2]
  def change
    create_table :student_lesson_progresses do |t|
    	t.references :student
    	t.references :lesson
    	t.references :lesson_part

      t.timestamps
    end
  end
end
